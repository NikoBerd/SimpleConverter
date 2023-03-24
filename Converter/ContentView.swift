//
//  ContentView.swift
//  Converter
//
//  Created by Niko on 23.03.23.
//

import SwiftUI

struct ContentView: View {

  var body: some View {
    VStack {
      NavigationView {
        ConverterView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct ConverterView: View {

  @State private var input = 100.0
  @State private var selectedUnits = 0
  @State private var inputUnit: Dimension = UnitLength.meters
  @State private var outputUnit: Dimension = UnitLength.kilometers
  @FocusState private var inputIsFocused: Bool

  let conversions = ["Distance", "Mass", "Temperature", "Time"]

  let unitTypes = [
    [UnitLength.feet, UnitLength.kilometers, UnitLength.meters, UnitLength.miles, UnitLength.yards],
    [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
    [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
    [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
  ]

  let units: [UnitLength] = [.feet, .kilometers, .meters, .miles, .yards]
  let formatter: MeasurementFormatter

  var result: String {
    let inputMeasurement = Measurement(value: input, unit: inputUnit)
    let outputMeasurement = inputMeasurement.converted(to: outputUnit)

    return formatter.string(from: outputMeasurement)
  }
  var body: some View {
    Form {
      Section {
        TextField("Amount", value: $input, format: .number)
          .keyboardType(.decimalPad)
          .focused($inputIsFocused)
      } header: {
        Text("Amount to convert")
      }

      Picker("Conversion", selection: $selectedUnits) {
        ForEach(0..<conversions.count) {
          Text(conversions[$0])
        }
      }

      Picker("Convert from", selection: $inputUnit) {
        ForEach(unitTypes[selectedUnits], id: \.self) {
          Text(formatter.string(from: $0).capitalized)
        }
      }

      Picker("Convert to", selection: $outputUnit) {
        ForEach(unitTypes[selectedUnits], id: \.self) {
          Text(formatter.string(from: $0).capitalized)
        }
      }


      Section {
        Text(result)
      } header: {
        Text("Result")
      }
    }
    .navigationTitle("Converter")
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()

        Button("Done") {
          inputIsFocused = false
        }
      }
    }
    .onChange(of: selectedUnits) { newSelection in
      let units = unitTypes[newSelection]
      inputUnit = units[0]
      outputUnit = units[1]
    }
  }

  init() {
    formatter = MeasurementFormatter()
    formatter.unitOptions = .providedUnit
    formatter.unitStyle = .long
  }
}

