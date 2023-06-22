// Create watermark label
let watermarkText = "My Watermark"
let watermarkFrame = CGRect(x: 0, y: 0, width: 200, height: 40)
let watermarkLabel = UILabel(frame: watermarkFrame)
watermarkLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
watermarkLabel.textAlignment = .center
watermarkLabel.text = watermarkText

// Add color to each character in the watermark text
let attributedString = NSMutableAttributedString(string: watermarkText)
attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 1))
attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: 1, length: 1))
attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 2, length: 1))
attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: 3, length: 1))
attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 4, length: 1))
attributedString.addAttribute(.foregroundColor, value: UIColor.purple, range: NSRange(location: 5, length: 1))
watermarkLabel.attributedText = attributedString

// Add watermark to window
if let window = UIApplication.shared.windows.first {
    window.addSubview(watermarkLabel)
}
