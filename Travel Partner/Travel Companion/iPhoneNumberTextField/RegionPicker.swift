//
//  RegionPicker.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/26/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI
import PhoneNumberKit

final class RegionPickerViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var searchResults: [Region] = []
    var regionData: [String: [Region]] = [:]
    
    init() {
        
        do {
            self.regionData = try decodeCountryMetadata(fileName: "regions.metadata")
        }
        catch {
            // Only asserts when in debug mode (ex. Simulator). Useful for debugging.
            assertionFailure(error.localizedDescription)
        }
        
        $text
            .map { [weak self] text in
                guard !text.isEmpty else {
                    return []
                }
                
                var searchResults: [Region] = []
                self?.regionData.forEach {
                    $0.value
                        .filter { $0.name?.lowercased().index(of: text.lowercased()) != nil }
                        .forEach {
                            searchResults.append($0)
                        }
                }
                
                return searchResults.sorted(by: {
                    if let lhs = $0.name, let rhs = $1.name {
                        return lhs < rhs
                    }
                    return true
                })
            }
            .assign(to: &$searchResults)
    }
    
    private func decodeCountryMetadata(fileName: String) throws -> [String: [Region]] {
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        guard let url = url else { throw URLError(.cannotOpenFile) }
        
        return try JSONDecoder().decode([String: [Region]].self, from: Data(contentsOf: url))
    }
    
    func findFullName(for code: String) -> String? {
        guard let key = code.first.map(String.init) else { return nil }
        return regionData[key]?.first(where: { $0.code == code })?.name
    }
    
    func findRegion(using code: String) -> Region? {
        var region: Region?
        
        regionData.values.forEach { regions in
            if let firstRegion = regions.first(where: { $0.code == code }) {
                region = firstRegion
                return
            }
        }
        return region
    }
}

struct RegionPicker: View {
    private typealias Colors = Constants.Colors.Views.iPhoneNumberTextField.RegionPicker
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = RegionPickerViewModel()
    @Binding private var selection: Region?
    @State private var currentLocationRegion: Region? = nil
    
    init(selection: Binding<Region?>) {
        self._selection = selection
    }
    
    private func select(_ region: Region) {
        selection = region
        presentationMode.wrappedValue.dismiss()
    }
    
    private func regionRow(region: Region) -> some View {
        HStack(spacing: 5) {
            Text(region.flagEmoji)
                .font(.system(size: 40))
            
            Text("\(region.name ?? region.code) (+\(region.dialCode))")
                .font(.system(size: 15, weight: .regular))
                .padding(.horizontal, 15)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .background(Colors.cellBackgroundColor)
    }
    
    private var header: some View {
        ZStack(alignment: .topLeading) {
            Colors.backgroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "multiply")
                }
                .font(.headline)
                
                Text("Select a Country")
                    .font(.system(size: 24, weight: .medium))
            }
            .foregroundColor(Colors.textColor)
            .padding(20)
        }
    }
    
    private var searchField: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Colors.SearchField.textColor)
                    .font(.system(size: 20))
                
                TextField("", text: $vm.text)
                    .customize { textField in
                        textField.placeholderAttributes(
                            placeholderText: "Search for a country",
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14),
                                .foregroundColor: UIColor(Colors.SearchField.placeholderColor)
                            ]
                        )
                    }
                    .accentColor(Colors.textColor)
            }
            .padding(.leading, 5)
            
            Rectangle()
                .fill(Colors.SearchField.textColor)
                .frame(height: 2)
                .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    private var orderedList: some View {
        ScrollView {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                if let selection = selection {
                    Section {
                        regionRow(region: selection)
                    }
                }
                
                if let currentLocationRegion = currentLocationRegion {
                    Section(header: HStack {
                        Text("Current Location")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Colors.currentLocationTextColor)
                            .padding(10)
                        
                        Spacer()
                    }
                    .background(Colors.backgroundColor)
                    ) {
                        Button(action: { select(currentLocationRegion) }) {
                            regionRow(region: currentLocationRegion)
                        }
                    }
                }
                
                ForEach(vm.regionData.sorted { $0.key < $1.key }, id: \.key) { letter, regions in
                    Section(header: HStack {
                        Text(letter)
                            .padding(10)
                            .padding(.top, 20)
                            .font(.system(size: 17, weight: .regular))
                        
                        Spacer()
                    }
                    .background(Colors.backgroundColor)
                    ) {
                        ForEach(regions) { region in
                            Button(action: { select(region) }) {
                                regionRow(region: region)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var searchList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 15) {
                if !vm.searchResults.isEmpty {
                    ForEach(vm.searchResults) { region in
                        Button(action: { select(region) }) {
                            regionRow(region: region)
                        }
                    }
                }
                else {
                    Text("No Results For \"\(vm.text)\"")
                        .font(.callout)
                        .foregroundColor(Colors.SearchField.placeholderColor)
                        .padding(10)
                        .lineLimit(1)
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Colors.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 10) {
                
                header
                
                searchField
                    .padding(.horizontal, 15)
                
                Group {
                    if vm.text.isEmpty {
                        orderedList
                    }
                    else {
                        searchList
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .layoutPriority(.greatestFiniteMagnitude)
            }
            .foregroundColor(Colors.textColor)
        }
        .onAppear {
            if let currentLocationRegion = vm.findRegion(using: PhoneNumberKit.defaultRegionCode()) {
                self.currentLocationRegion = currentLocationRegion
            }
            
            if let selection = selection,
               selection.name == nil,
               let region = vm.findRegion(using: selection.code) {
                self.selection = region
            }
        }
    }
}

struct RegionPicker_Previews: PreviewProvider {
    static var previews: some View {
        RegionPicker(selection: .constant(Region(code: "US", dialCode: 1, name: "United States")))
    }
}
