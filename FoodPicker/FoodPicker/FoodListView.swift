//
//  FoodListView.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//

import SwiftUI

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.dynamicTypeSize) var textSize
    @State private var food = Food.examples
    @State private var selectedFood = Set<Food.ID>()
    @State private var shouldShowSheet: Bool = false
    @State private var foodDetailHeight: CGFloat = FoodDetailSheetHeightKey.defaultValue
    
    var isEditing: Bool {editMode?.wrappedValue == .active}
    var body: some View {
        VStack (alignment: .leading) {
            titleBar
            
            List($food, editActions: .all, selection: $selectedFood) {$food in
                HStack {
                    Text(food.name).padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isEditing {return}
                            shouldShowSheet = true
                        }
                    
                    if isEditing {
                        Image(systemName: "pencil")
                            .font(.title2.bold())
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(isPresented: $shouldShowSheet) {
            let food = food[4]
            let shouldUseVStack = textSize.isAccessibilitySize || food.image.count > 1
            
            AnyLayout.useVStack(if: shouldUseVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(shouldUseVStack ? 1 : 0.5)
                Grid(horizontalSpacing: 30, verticalSpacing: 12) {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                }
            }
            .padding()
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height )
                }
            }
            .onPreferenceChange(FoodDetailSheetHeightKey.self) {
                foodDetailHeight = $0
            }
            .presentationDetents([.height(foodDetailHeight)])
        }
    }
}

private extension FoodListView {
    struct FoodDetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 300
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

private extension FoodListView {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: "fork.knife")
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            EditButton()
                .buttonStyle(.bordered)
        }.padding()
    }
    
    var addButton: some View {
        Button {} label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor)
        }
    }
    
    var removeButton: some View {
        Button {
            withAnimation {
                food = food.filter{ !selectedFood.contains($0.id)}
            }
        } label: {
            Text("删除已选项目")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }.mainButtonStyle(shape: .roundedRectangle(radius: 6))
            .padding(.horizontal, 50)
    }
    
    func buildFloatButton() -> some View {
        ZStack {
            removeButton
                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                .opacity(isEditing ? 1 : 0)
                .id(isEditing)
            
            HStack {
                Spacer()
                addButton
                    .scaleEffect(isEditing ? 0 : 1)
                    .opacity(isEditing ? 0 : 1)
                    .animation(.easeInOut, value: isEditing)
            }
        }
    }
    
    func buildNutritionView(title: String, value: String) -> some View {
        GridRow {
            Text(title).gridCellAnchor(.leading)
            Text(value).gridCellAnchor(.trailing)
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
