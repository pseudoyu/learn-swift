//
//  FoodListView.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//

import SwiftUI

private enum Sheet: View, Identifiable {
    case newFood((Food) -> Void)
    case editFood(Binding<Food>)
    case foodDetail(Food)
    
    var id: UUID {
        switch self {
        case .newFood:
            return UUID()
        case .editFood(let binding):
            return binding.wrappedValue.id
        case .foodDetail(let food):
            return food.id
        }
    }
    
    var body: some View {
        switch self {
        case .newFood(let onSubmit):
            FoodListView.FoodForm(food: .new, onSubmit: onSubmit)
        case .editFood(let binding):
            FoodListView.FoodForm(food: binding.wrappedValue){ binding.wrappedValue = $0 }
        case .foodDetail(let food):
            FoodListView.FoodDetailSheet(food: food)
        }
    }
}

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @State private var food = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    
    @State private var sheet: Sheet?
    
    var isEditing: Bool {editMode?.wrappedValue == .active}
    var body: some View {
        VStack (alignment: .leading) {
            titleBar
            
            List($food, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRow)
            .listStyle(.plain)
            .padding(.horizontal)
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(item: $sheet) {$0}
    }
}

private extension FoodListView {
    struct FoodDetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 300
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct FoodDetailSheet: View {
        @Environment(\.dynamicTypeSize) private  var textSize
        @State private var foodDetailHeight: CGFloat = FoodDetailSheetHeightKey.defaultValue
        let food: Food
        var body: some View {
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
                    Color.clear.preference(key: FoodListView.FoodDetailSheetHeightKey.self, value: proxy.size.height )
                }
            }
            .onPreferenceChange(FoodListView.FoodDetailSheetHeightKey.self) {
                foodDetailHeight = $0
            }
            .presentationDetents([.height(foodDetailHeight)])
        }
        
        func buildNutritionView(title: String, value: String) -> some View {
            GridRow {
                Text(title).gridCellAnchor(.leading)
                Text(value).gridCellAnchor(.trailing)
            }
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
        Button {
            sheet = .newFood {
                food.append($0)
            }
        } label: {
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
                food = food.filter{ !selectedFoodID.contains($0.id)}
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
    
    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name).padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing {
                        selectedFoodID.insert(food.id)
                        return
                    }
                    sheet = .foodDetail(food)
                }
            
            if isEditing {
                Image(systemName: "pencil")
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
