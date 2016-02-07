import UIKit
//Given Image
let image = UIImage(named: "sample")!
protocol myFilterProtocol {
    func applyFilter(inputImage: UIImage) -> UIImage
}

class myFilter: myFilterProtocol {
    func applyFilter(inputImage: UIImage) -> UIImage {
        return inputImage
    }
}

class RedFilter : myFilter {
    override func applyFilter(image: UIImage) -> UIImage{
        //Manipulating UI image by itself is not possible(atleast not easy). So convert it into RGBA image which is provided through the RGBAImage.swift. We get a variable that contains Image Pixels that can individually be manipulated.
        let rgbaImage = RGBAImage(image: image)!
        var totalRed = 0
        let pixelCount = rgbaImage.width * rgbaImage.height
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                // Create an Index as to where in the RGBAImage the pixel corresponds to.
                let index = y * rgbaImage.width + x
                //2D Images as 1D stacked Array.
                let pixel = rgbaImage.pixels[index]
                totalRed += Int(pixel.red)
                
            }
        }
        let avgRed = totalRed/pixelCount
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let redDelta = Int(pixel.red) - avgRed
                pixel.red = UInt8(max(min(255, avgRed + 2 * redDelta), 0))
                rgbaImage.pixels[index] = pixel
            }
        }
        let finished = rgbaImage.toUIImage()!
        return (finished)
    }
}

class BlueFilter : myFilter {
    override func applyFilter(image: UIImage) -> UIImage{
        let rgbaImage = RGBAImage(image: image)!
        var totalBlue = 0
        let pixelCount = rgbaImage.width * rgbaImage.height
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                totalBlue += Int(pixel.blue)
            }
        }
        let avgBlue = totalBlue/pixelCount
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let blueDelta = Int(pixel.blue) - avgBlue
                pixel.blue = UInt8(max(min(255, avgBlue + 4 * blueDelta), 0))
                rgbaImage.pixels[index] = pixel
                
                
            }
        }
        let finished = rgbaImage.toUIImage()!
        return (finished)
    }
}


class GreenFilter : myFilter {
    override func applyFilter(image: UIImage) -> UIImage{
        let rgbaImage = RGBAImage(image: image)!
        var totalGreen = 0
        let pixelCount = rgbaImage.width * rgbaImage.height
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                totalGreen += Int(pixel.blue)
            }
        }
        
        
        let avgGreen = totalGreen/pixelCount
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let greenDelta = Int(pixel.green) - avgGreen
                pixel.green = UInt8(max(min(255, avgGreen + greenDelta/3), 0))
                rgbaImage.pixels[index] = pixel
            }
        }
        let finished = rgbaImage.toUIImage()!
        return (finished)
    }
}


class ContrastFilter : myFilter {
    internal var param: Int = 0
    
    override init() {
        self.param = 100;
    }
    
    init(param: Int) {
        if param > 255 {
            self.param = 255
        }
        else if param < -255 {
            self.param = -255
        }
        else {
            self.param = param
        }
    }
    override func applyFilter(image: UIImage) -> UIImage{
        let rgbaImage = RGBAImage(image: image)!
        let factor = Float(259*(param + 255) / 255 / (259 - param))
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                pixel.red = UInt8(max(min(255, factor * (Float(pixel.red) - 128.0) + 128.0), 0))
                pixel.green = UInt8(max(min(255,  factor * (Float(pixel.green) - 128.0) + 128.0), 0))
                pixel.blue = UInt8(max(min(255,  factor * (Float(pixel.blue) - 128.0) + 128.0), 0))
                rgbaImage.pixels[index] = pixel
            }
        }
        let finished = rgbaImage.toUIImage()!
        return (finished)
    }
}

class GrayscaleFilter : myFilter {
    internal var param: Int = 0
    
    override init() {
        
    }
    
    init(param: Int) {
        self.param = param
    }
    override func applyFilter(image: UIImage) -> UIImage{
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                var color = Float(pixel.red) * 0.12
                color += Float(pixel.green) * 0.71
                color += Float(pixel.blue) * 0.07
                let gs = UInt8(max(min(255, color), 0))
                pixel.red = gs
                pixel.green = gs
                pixel.blue = gs
                rgbaImage.pixels[index] = pixel
            }
        }
        let finished = rgbaImage.toUIImage()!
        return (finished)
    }
}


class myImageProcessor {
    var myFilters = [myFilter]()
    
    // Default initializer
    init(){
        let aRedFilter = RedFilter()
        myFilters.append(aRedFilter)
    }
    
    // Initializer (Passing in an array of filter instances)
    init( inputFilters: [myFilter] ){
        for x in 0..<inputFilters.count{
            myFilters.append(inputFilters[x])
        }
    }
    
    // Initializer (passing in an array of strings)
    init( inputFilters: [String] ){
        
        for x in 0..<inputFilters.count {
            switch inputFilters[x] {
            case "Red":
                myFilters.append(RedFilter())
                
            case "Blue":
                myFilters.append(BlueFilter())
                
            case "Green":
                myFilters.append(GreenFilter())
                
            case "Gray":
                myFilters.append(GrayscaleFilter())
                
            case "Contrast":
                myFilters.append(ContrastFilter())
                
            default: // in default case, append filter that doesn't do anything
                myFilters.append(myFilter())
            }
        }
    }
    
    func applyFilters(inputImage: UIImage) -> UIImage {
        var outputImage = inputImage
        for x in 0..<myFilters.count {
            outputImage = myFilters[x].applyFilter(outputImage)
        }
        return outputImage
    }
}
//INTERFACE A
//Interface specifying the order for an arbitrary number of filter calculations that should be applied to an image.
// UNCOMMENT THE LINES OF CODE INSIDE INTERFACE B WHEN YOU IMPLEMENT INTERFACE A.
/***********CODE FOR IMPLEMENTING INTERFACE A**************/
//let myFilter1 = RedFilter()
//let myFilter2 = BlueFilter()
//let myImageProcessorInstance = myImageProcessor(inputFilters: [myFilter1, myFilter2])
//let outputImage = myImageProcessorInstance.applyFilters(image)


//INTERFACE B
//Interface to apply specific default filter formulae/parameters to the image, by specifying each configuration’s name as a String.
//UNCOMMENT THE LINES OF CODE INSIDE INTERFACE A WHEN YOU IMPLEMENT INTERFACE B
/****************CODE FOR IMPLEMENTING INTERFACE B*********************/
let myImageProcessorInstance = myImageProcessor(inputFilters: [ "Red","Blue","Green","Contrast", "Gray"])
let outputImage = myImageProcessorInstance.applyFilters(image)

