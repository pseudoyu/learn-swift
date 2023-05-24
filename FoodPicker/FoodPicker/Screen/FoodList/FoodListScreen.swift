//
//  FoodListScreen.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//

import SwiftUI

struct FoodListScreen: View {
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
        .sheet(item: $sheet)
    }
}

private extension FoodListScreen {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: .forkAndKnife)
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .push(to: .leading)
            
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
            SFSymbol.plus
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
                .maxWidth()
        }.mainButtonStyle(shape: .roundedRectangle(radius: 6))
            .padding(.horizontal, 50)
    }
    
    func buildFloatButton() -> some View {
        ZStack {
            removeButton
                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                .opacity(isEditing ? 1 : 0)
                .id(isEditing)
            
            addButton
                .scaleEffect(isEditing ? 0 : 1)
                .opacity(isEditing ? 0 : 1)
                .animation(.easeInOut, value: isEditing)
                .push(to: .trailing)
    }
    }
    
    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name).padding(.vertical, 10)
                .push(to: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing {
                        selectedFoodID.insert(food.id)
                        return
                    }
                    sheet = .foodDetail(food)
                }
            
            if isEditing {
                SFSymbol.pencil
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

struct FoodListScreen_Previews: PreviewProvider {
    static var previews: some View {
        FoodListScreen()
    }
}
