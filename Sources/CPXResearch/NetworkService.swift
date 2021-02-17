//
//  NetworkService.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

import Foundation

final class NetworkService {
    private let imageCache = NetworkCache()

    private let surveyListBaseUrl = "https://offers.cpx-research.com/index.php"
    private let baseUrl = "https://live-api.cpx-research.com/api/get-surveys.php"
    private let imageBaseUrl = "https://dyn-image.cpx-research.com/image"

    enum ApiError: Error {
        case noDataReceived
        case convertError(Error)
    }

    func surveyUrl(_ config: CPXConfiguration, showSurvey surveyId: String? = nil) -> URL? {
        var queryItems = config.queryItems
        queryItems.append(URLQueryItem(name: Const.noClose, value: String(true)))
        if let surveyId = surveyId {
            queryItems.append(URLQueryItem(name: Const.surveyId, value: surveyId))
        }

        var urlComps = URLComponents(string: surveyListBaseUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return nil }
        return url
    }

    func hideDialogUrl(_ config: CPXConfiguration) -> URL? {
        var queryItems = config.queryItems
        queryItems.append(URLQueryItem(name: Const.noClose, value: String(true)))
        queryItems.append(URLQueryItem(name: Const.site, value: "settings-webview"))

        var urlComps = URLComponents(string: surveyListBaseUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return nil }
        return url
    }

    func helpSiteUrl(_ config: CPXConfiguration) -> URL? {
        var queryItems = config.queryItems
        queryItems.append(URLQueryItem(name: Const.noClose, value: String(true)))
        queryItems.append(URLQueryItem(name: Const.site, value: "help"))

        var urlComps = URLComponents(string: surveyListBaseUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return nil }
        return url
    }

    func requestSurveysFromApi(_ config: CPXConfiguration,
                               additionalQueryItems: [URLQueryItem]?,
                               onCompletion: @escaping ((Result<SurveyModel, Error>) -> Void)) {

        var queryItems = config.queryItems
        queryItems.append(URLQueryItem(name: Const.outputMethod, value: "jsscriptv1"))
        
        if let additionalItems = additionalQueryItems {
            queryItems.append(contentsOf: additionalItems)
        }
        var urlComps = URLComponents(string: baseUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return }

        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: 30)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onCompletion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let model = try JSONDecoder().decode(SurveyModel.self, from: data)
                    onCompletion(.success(model))
                } catch {
                    onCompletion(.failure(ApiError.convertError(error)))
                }

            } else {
                onCompletion(.failure(ApiError.noDataReceived))
            }

        }.resume()
    }

    func requestImageFor(_ config: CPXConfiguration,
                         onCompletion: @escaping ((Result<ResponseModel, Error>) -> Void)) {
        let queryItems = config.queryItems

        var urlComps = URLComponents(string: imageBaseUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return }

        if let model: ResponseModel = imageCache.retrieve(forKey: url.absoluteString) {
            onCompletion(.success(model))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                onCompletion(.failure(error))
                return
            }

            if let data = data,
               let mime = response?.mimeType {
                let model = ResponseModel(data: data,
                                          mime: mime)
                self.imageCache.put(model, forKey: url.absoluteString)
                onCompletion(.success(model))
            } else {
                onCompletion(.failure(ApiError.noDataReceived))
            }
        }.resume()
    }

    func clearCache() {
        imageCache.clear()
    }
}
