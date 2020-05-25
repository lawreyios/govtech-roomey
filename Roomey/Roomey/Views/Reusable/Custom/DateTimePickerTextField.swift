//
//  DateTimePickerTextField.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

class NonPastableTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

struct DateTimePickerTextField: UIViewRepresentable {
    
    @Binding var text: String
    var mode: UIDatePicker.Mode
    var onSearch: () -> Void
    var isFirstResponder = false
    
    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var mode: UIDatePicker.Mode
        var onSearch: () -> Void
        var didBecomeFirstResponder = false
        var dateFormatter = DateFormatter()
        
        private lazy var datePickerView: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.date = Date()
            datePicker.datePickerMode = mode
            datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
            datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            datePicker.minuteInterval = 30
            datePicker.addTarget(self, action: #selector(handleDatePickerInput(from:)), for: .valueChanged)
            return datePicker
        }()

        init(text: Binding<String>, mode: UIDatePicker.Mode, onSearch: @escaping () -> Void) {
            _text = text
            self.mode = mode
            self.onSearch = onSearch
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.inputView = datePickerView
            
            if mode == .date {
                dateFormatter.dateFormat = DateTimeFormat.dateWithMonthName
                text = dateFormatter.string(from: Date())
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if mode == .time {
                onSearch()
            }
        }
        
        @objc func handleDatePickerInput(from picker: UIDatePicker) {
            dateFormatter.dateFormat = mode == .date
                ? DateTimeFormat.dateWithMonthName
                : DateTimeFormat.timeWithAMPM
            text = dateFormatter.string(from: picker.date.nearestThirtySeconds())
        }
    }

    func makeUIView(context: UIViewRepresentableContext<DateTimePickerTextField>) -> NonPastableTextField {
        let textField = NonPastableTextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textColor = .black
        textField.font = UIFont(name: SMFont.regular, size: 14.0)
        if mode == .date { textField.inputAccessoryView = UIView() }
        return textField
    }

    func makeCoordinator() -> DateTimePickerTextField.Coordinator {
        return Coordinator(text: $text, mode: mode, onSearch: onSearch)
    }

    func updateUIView(_ uiView: NonPastableTextField, context: UIViewRepresentableContext<DateTimePickerTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

}

