import Foundation

class MainScene: CCNode, RequestDelegate {
    
    let brightColor = CCColor(red:0.8, green:0.8, blue:0.8)
    let midColor = CCColor(red:0.5, green:0.5, blue:0.5)
    let darkColor = CCColor(red:0.2, green:0.2, blue:0.2)
    
    var increment = 0
    var updateFrequency = 2
    
    var pixelNode = CCNode()
    
    var drawing:Drawing
    var center:CGPoint
    var origin:CGPoint
    
    var pixelWidth = 25
    var pixelHeight = 25
    
    var atlas:ATLAS
    
    override init()
    {
        // width = COLS = x
        // height = ROWS = y
        drawing = Drawing(width:7, height:7)
        
//        drawing.addPixel(2, y:6, v:1)
//        drawing.addPixel(3, y:6, v:1)
//        drawing.addPixel(4, y:6, v:1)
//        drawing.addPixel(5, y:5, v:1)
//        drawing.addPixel(6, y:4, v:1)
//        drawing.addPixel(6, y:3, v:1)
//        drawing.addPixel(6, y:2, v:1)
//        drawing.addPixel(5, y:1, v:1)
//        drawing.addPixel(4, y:0, v:1)
//        drawing.addPixel(3, y:0, v:1)
//        drawing.addPixel(2, y:0, v:1)
//        drawing.addPixel(1, y:1, v:1)
//        drawing.addPixel(0, y:2, v:1)
//        drawing.addPixel(0, y:3, v:1)
//        drawing.addPixel(0, y:4, v:1)
//        drawing.addPixel(1, y:5, v:1)
        
        self.atlas = ATLAS()
        
        center = ccp(400.0, 250.0)
        origin = ccp(center.x - CGFloat(drawing.pixels.cols * pixelWidth)/2, center.y - CGFloat(drawing.pixels.rows * pixelHeight)/2)
        
        super.init()
    }
    
    override func onEnter()
    {
        // Call this FIRST
        super.onEnter()
        
        // Get rid of all the pre-built spritebuilder crap
        self.removeAllChildren()
        
        self.addChild(pixelNode)
        
        atlas.setDelegate(self)
//        atlas.represent("line", drawing:drawing)
        
        let layer = DBNLayer(visible:9, hidden:18)
        layer.trainInstance([0,1,0,1,0,1,0,1,0])
        
        redrawDrawing()
    }

    func redrawDrawing()
    {
        for x in 0..<drawing.pixels.rows
        {
            let rowNode = CCNode()
            pixelNode.addChild(rowNode)
            for y in 0..<drawing.pixels.cols
            {
                let pixel:Int = drawing.pixels[x,y]
                
                let spriteName = "square.png"
                var spriteColor = colorForValue(pixel)
                
                var sprite = CCSprite(imageNamed:spriteName)
                sprite.resizeNode(Double(pixelWidth), y:Double(pixelHeight))
                sprite.position = screenCoordsForPixelCoords(Float(x), y:Float(y), b:Float(1))
                sprite.color = spriteColor
                rowNode.addChild(sprite)
            }
        }
    }
    
    func recolorDrawing()
    {
        for x in 0..<drawing.pixels.rows
        {
            for y in 0..<drawing.pixels.cols
            {
                let pixel:Int = drawing.pixels[x,y]
                let rowNode = pixelNode.children[x] as! CCNode
                let pixelSprite = rowNode.children[y] as! CCSprite
                
                pixelSprite.color = colorForValue(pixel)
            }
        }
    }
    
    func colorForValue(pixel:Int) -> CCColor
    {
        var spriteColor = CCColor()
        
        switch(pixel)
        {
        case 0:
            spriteColor = darkColor
            break
        case 1:
            spriteColor = midColor
            break
        case 2:
            spriteColor = brightColor
            break
        default:
            spriteColor = darkColor
            break
        }
        
        return spriteColor
    }
    
    func screenCoordsForPixelCoords(x:Float, y:Float, b:Float) -> CGPoint
    {
        return ccp(origin.x + CGFloat(x * Float(Float(pixelWidth) + b)), origin.y + CGFloat(y * Float(Float(pixelHeight) + b)))
    }
    
    override func onExit()
    {
        // Call this LAST
        super.onExit()
    }
    
    override func update(delta: CCTime)
    {
        updateIncrement()
        
        if (increment % updateFrequency == 0)
        {
            drawing.popBuffer()
            recolorDrawing()
        }
    }
    
    func updateIncrement()
    {
        increment++
        if (increment == 10000)
        {
            increment = 1
        }
    }
    
    // REQUEST DELEGATE
    func requestUnknown(request:String)
    {
        // HANDLE IT
    }
}
