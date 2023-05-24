//
//  FoodListScreen.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//

import SwiftUI

struct FoodListScreen: View {
    @State private var editMode: EditMode = .inactive
    @State private var food = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    
    @State private var sheet: Sheet?
    
    var isEditing: Bool {editMode.isEditing}
    var body: some View {
        VStack (alignment: .leading) {
            titleBar
            
            List($food, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRow)
                .listStyle(.plain)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.groupBg2)
                        .ignoresSafeArea(.container, edges: .bottom)
                }
                .padding(.horizontal)
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .environment(\.editMode, $editMode)
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
            
            addButton
        }.padding()
    }
    
    var addButton: some View {
        Button {
            sheet = .newFood {
                food.append($0)
            }
        } label: {
            SFSymbol.plus
                .font(.system(size: 40))
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
        removeButton
            .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
            .opacity(isEditing ? 1 : 0)
            .id(isEditing)
            .padding(.bottom)
    }
    
    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name).font(.title3).padding(.vertical, 10)
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
