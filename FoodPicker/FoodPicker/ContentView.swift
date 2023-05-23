//
//  ContentView.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedFood: Food?
    @State private var shouldShowInfo: Bool = false
    
    let food = Food.examples
    
    var body: some View {
        ScrollView {
            VStack (spacing: 30) {
                
                foodImage
                
                Text("今天吃什么？").bold()
                
                selectedFoodInfoView
                
                Spacer().layoutPriority(1)
                
                selectFoodButton
                
                cancelFoodButton
                
            }
            .font(.title)
            .padding()
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 100)
            .mainButtonStyle()
            .animation(.mySpring, value: shouldShowInfo)
            .animation(.myEase, value: selectedFood)
        }.background(.bg2)
    }
}

private extension ContentView {
    var foodImage: some View {
        Group {
            if selectedFood != .none {
                Text(selectedFood!.image)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
            } else {
                Image("dinner")
                    .resizable()
                    .scaledToFit()
            }
        }.frame(height: 250)
    }
    
    var foodNameView: some View {
        HStack {
            Text(selectedFood!.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
                .id(selectedFood!.name)
                .transition(.delayInsertionOpacity)
            
            
            Button {
                shouldShowInfo.toggle()
            } label : {
                Image(systemName: "info.circle.fill").foregroundColor(.secondary)
            }.buttonStyle(.plain)
        }
    }
    
    var foodDetailView: some View {
                    VStack {
                        if shouldShowInfo {
                            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                                GridRow {
                                    Text("蛋白质")
                                    Text("脂肪")
                                    Text("碳水")
                                }.frame(minWidth: 60)
                                
                                Divider().gridCellUnsizedAxes(.horizontal).padding(.horizontal, -10)
                                
                                GridRow {
                                    Text(selectedFood!.$protein)
                                    Text(selectedFood!.$fat)
                                    Text(selectedFood!.$carb)
                                }
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .padding()
                            .roundedRectBackgroud()
                            .transition(.moveUpWithOpacity)
                        }
                    }
                    .clipped()
    }
    
    var selectFoodButton: some View {
        Button {
            selectedFood = food.shuffled().filter { $0 != selectedFood }.first
        } label: {
            Text(selectedFood == .none ? "告诉我" : "换一个").frame(width: 200, alignment: .center).transformEffect(.identity).animation(.none, value: selectedFood)
        }
            .buttonStyle(BorderedProminentButtonStyle())
            .buttonBorderShape(.capsule)
    }
    
    var cancelFoodButton: some View {
        Button {
            selectedFood = .none
            shouldShowInfo = false
        } label: {
            Text("重置").frame(width: 200, alignment: .center)
        }
        .buttonStyle(BorderedButtonStyle())
        .buttonBorderShape(.capsule)
    }

    @ViewBuilder var selectedFoodInfoView: some View {
        if selectedFood != .none {
            
            foodNameView
            
            Text("热量 \(selectedFood!.$calorie)")
        
            foodDetailView
        }
    }
}

extension ContentView {
    init(selectedFood: Food) {
        _selectedFood = State(wrappedValue: selectedFood)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedFood: .examples.first!)
        ContentView(selectedFood: .examples.first!).previewDevice(.iPad)
        ContentView(selectedFood: .examples.first!).previewDevice(.iPhoneSE)
    }
}
