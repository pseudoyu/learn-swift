//
//  SettingScreen.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/24.
//

import SwiftUI

enum Unit: String, CaseIterable, Identifiable, View {
    case gram = "g", pound = "lb"
    
    var id: Self { self }
    
    var body: some View {
        Text(rawValue)
    }
}

struct SettingScreen: View {
    @State private var shouldUseDarkMode: Bool = false
    @State private var unit: Unit = .gram
    @State private var startTab: HomeScreen.Tab = .picker
    @State private var confirmationDialog: Dialog = .inactive
    
    private var shouldShowDialog: Binding<Bool> {
        Binding(
            get: { confirmationDialog != .inactive },
            set: { _ in confirmationDialog = .inactive }
        )
    }
    
    var body: some View {
        Form {
            Section("基本设定") {
                Toggle(isOn: $shouldUseDarkMode) {
                    Label("深色模式", systemImage: .moon)
                }
                
                Picker(selection: $unit) {
                    ForEach(Unit.allCases) { $0 }
                } label: {
                    Label("单位", systemImage: .unitSign)
                }.pickerStyle(.menu)
                
                Picker(selection: $startTab) {
                    Text("随机食物").tag(HomeScreen.Tab.picker)
                    Text("食物清单").tag(HomeScreen.Tab.list)
                } label: {
                    Label("启动画面", systemImage: .house)
                }
            }
            
            Section("危险区域") {
                ForEach(Dialog.allCases) { dialog in
                    Button(dialog.rawValue) {confirmationDialog = dialog}
                        .tint(Color(.label))
                }
            }
            .confirmationDialog(confirmationDialog.rawValue, isPresented: shouldShowDialog, titleVisibility: .visible) {
                Button("确定", role: .destructive){}
                Button("取消", role: .cancel) {}
            } message: {
                Text(confirmationDialog.message)
            }
        }
    }
}

private enum Dialog: String {
    case resetSettings = "重置設定"
    case resetFoodList = "重置食物紀錄"
    case inactive
    
    var message: String {
        switch self {
            case .resetSettings:
                return "將重置顏色、單位等設置，\n此操作無法復原，確定進行嗎？"
            case .resetFoodList:
                return "將重置食物清單，\n此操作無法復原，確定進行嗎？"
            case .inactive:
                return ""
        }
    }
}

extension Dialog: CaseIterable {
    static let allCases: [Dialog] = [.resetSettings, .resetFoodList]
}

extension Dialog: Identifiable {
    var id: Self { self }
}

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreen()
    }
}
