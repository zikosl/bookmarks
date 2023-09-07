//
//  ListItem.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//
/**
import SwiftUI
import Accelerate.vImage

struct ListItems: View {
    
    @State private var backgroundColor: Color = .white
    var item:Books
    var size:CGFloat = 44
    
    @State var saved:Bool = false
    @State var visible:Bool = false
    @Environment(\.openURL) var openURL

    @EnvironmentObject var data:mycolors
    @State private var showShareSheet = false

    var body: some View {
            HStack(alignment: .center){
                URLButton(content: HStack{
                    ZStack{
                        Image(uiImage: resizeImageWithAspect(image: item.icon, scaledToMaxWidth: size, maxHeight: size)!)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                    }
                    .frame(width: size * 2 - 10 , height: size*2 - 10)
                    .background(backgroundColor)
                    .cornerRadius(8)
                    .padding(.trailing,10)
                    VStack(alignment: .center, spacing: 6){
                        HStack(alignment:.top){
                            Text(item.title)
                                .font(.custom("Poppins-SemiBold",size: 17))
                                .foregroundColor(Color("blue"))
                                .fontWeight(.bold)
                            Spacer()
                            if(!item.disabled){
                                Button(action: {
                                    data.FavoriteCategorie(id:item.id)
                                }, label: {
                                    Image(systemName: self.saved ? "star.fill" : "star")
                                        .font(.system(size: 13))
                                        .foregroundColor( self.saved ? Color("liked") : .gray)
                                })
                            }
                        }
                        Text(item.detaille)
                            .font(.custom("Poppins-Medium",size: 13))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .padding(.vertical)
                }, url: item.link)
                Spacer()
                ZStack{
                    Button(action: {
                        self.showShareSheet = true
                    }, label: {
                        VStack{
                            
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 13))
                                .foregroundColor(Color("color6"))
                                
                            Spacer()
                        }
                        .padding(.vertical,18)
                    })
                    
                    if(!item.disabled)
                    {
                        Menu{
                            Button{
                                self.visible = true
                            } label: {
                                HStack{
                                    Button(action: {
                                        withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                            self.saved.toggle()
                                        }
                                    }, label: {
                                        Image(systemName: "applepencil")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray.opacity(0.7))
                                            .rotationEffect(.init(degrees: 90))
                                    })
                                    Text("Edit")
                                        .font(.custom("Poppins-Medium",size: 13))
                                        .foregroundColor(Color.black)
                                }
                            }
                            Button{
                                data.RemoveFromCategorie(id: item.id)

                            } label: {
                                HStack{
                                    Button {
                                        withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                            self.saved.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray.opacity(0.7))
                                            .rotationEffect(.init(degrees: 90))
                                    }
                                    Text("Remove")
                                        .font(.custom("Poppins-Medium",size: 13))
                                        .foregroundColor(Color.black)
                                }
                            }
                        } label: {
                            ZStack{
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.7))
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .frame(width: 40, height: 40)
                        }
                    }
                }
                
                
            }
            .frame(height:150)
            .padding(.horizontal,20)
            .padding(.vertical,1)
            .background(Color("light"))
            .cornerRadius(20)
            .padding(.horizontal,8)
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [item.link])
            }
            .onChange(of: item.favorit, perform: { newValue in
                withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                    self.saved = newValue
                }
            })
            .onAppear {
                        self.saved = item.favorit
                        //self.setAverageColor()
            }
            .sheet(isPresented: $visible) {
                UpdateBook(values: item)
            }
    }
    private func setAverageColor() {
        let uiColor = item.icon.firstColor ?? .clear
        backgroundColor = Color(uiColor)
    }
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
}

extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var firstColor: UIColor? {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return nil }

       
        let outputImage = inputImage

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor? {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return nil }

        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

 */
