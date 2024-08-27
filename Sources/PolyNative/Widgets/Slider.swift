import AppKit
import Foundation

private class PolySliderCallback: Callback {
    let handle: CallbackHandle

    private let context: ApplicationContext

    init(handle: CallbackHandle, context: ApplicationContext) {
        self.handle = handle
        self.context = context
    }

    @objc
    func call(_ sender: NSSlider) {
        let event = SliderValueChangedEvent(newValue: sender.doubleValue)
        context.portableLayer.invokeVoidCallback(handle, event) { _ in }
    }
}

@MainActor
func makeSlider(with message: Slider, context: ApplicationContext) -> NSSlider {
    let target = PolySliderCallback(handle: message.onValueChanged, context: context)
    context.callbackRegistry.register(target)
    return .init(value: message.value, minValue: message.minValue, maxValue: message.maxValue, target: target, action: #selector(PolySliderCallback.call(_:)))
}

@MainActor
func makeSlider<Parent: NSView>(with message: Slider, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSSlider {
    let target = PolySliderCallback(handle: message.onValueChanged, context: context)
    context.callbackRegistry.register(target)
    let slider = NSSlider(value: message.value, minValue: message.minValue, maxValue: message.maxValue, target: target, action: #selector(PolySliderCallback.call(_:)))

    commit(slider, parent)
    
    slider.translatesAutoresizingMaskIntoConstraints = false
    
    if message.width != minContent {
        if message.width == fillParent {
            slider.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            slider.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }

    return slider
}
