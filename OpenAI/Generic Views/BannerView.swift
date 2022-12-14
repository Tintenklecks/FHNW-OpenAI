//
//  BannerView.swift
//  OpenAI
//
//  Created by Ingo Boehme on 13.12.22.
//

import SwiftUI

struct BannerView: View {
    @Binding var showing: Bool
    let type: BannerType
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: type.symbolName)
                .padding(.horizontal)

            Text(type.text)
                .bold()
            Spacer()
            Button {
                withAnimation {
                    showing = false
                }
            } label: {
                Image(systemName: "x.circle.fill")
            }
        }
        .padding(8)
        .background(type.color)

        .foregroundColor(.white)
        .onAppear {
            if let hideAfter = type.hideAfter {
                DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter) {
                    withAnimation {
                        showing = false
                    }
                }
            }
        }
    }
    
    public enum BannerType {
        case info(String)
        case noInternet
        case error(String)
        
        var color: Color {
            switch self {
            case .noInternet:
                return .gray
            case .error:
                return .red
            case .info:
                return .blue
            }
        }
        
        var symbolName: String {
            switch self {
            case .info: return "info.circle.fill"
                
            case .noInternet: return "wifi.exclamationmark"
                
            case .error: return "exclamationmark.circle.fill"
            }
        }
        
        var hideAfter: Double? {
            switch self {
            case .info:
                return 2.0
            case .error:
                return 2.0
            default:
                return nil
            }
        }
        
        var text: String {
            switch self {
            case .info(let text): return text
            case .noInternet: return "No Internet Connection available"
            case .error(let text): return text
            }
        }
    }
}
