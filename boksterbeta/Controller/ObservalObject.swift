//
//  ObservalObject.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//
import SwiftUI
import LinkPresentation
import SwiftLinkPreview

func addImage(id:Int,title:String,stitle:String,image:UIImage,value:myDatabase){
    let icon = UUID().uuidString;
    print("ico00n -> \(icon)")
    // Convert to Data
    if let data = image.pngData() {
        print("icon -> \(icon)")
        // Create URL
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(icon)

        do {
            // Write to Disk
            try data.write(to: url)
            
            // Store URL in User Defaults
            UserDefaults.standard.set(url, forKey: icon)
            value.updateLinkFull(item: LinkesItems(id: id,link: "",  title: title, detaille: stitle, icon: icon))
        } catch {
            print("Unable to Write Data to Disk (\(error))")
        }
    }
    else{
    }
}

class PreviwLinkCustom : ObservableObject {
    
    let slp = SwiftLinkPreview(session: URLSession.shared,
                   workQueue: SwiftLinkPreview.defaultWorkQueue,
                   responseQueue: DispatchQueue.main,
                       cache: InMemoryCache())
    
    @Published var title : String?
    @Published var detaille : String?
    @Published var image : UIImage?
    var preview:Cancellable?
    
    func loadurl(link:Itemurl,db:myDatabase,funct:@escaping ()->Void){
        if let cached = self.slp.cache.slp_getCachedResponse(url: link.url) {
            self.title = cached.title
            let str:String = cached.description ?? "No Preview About This URL"
            self.detaille = str
            print(str)
            DispatchQueue.global().async { [weak self] in
                if let values = cached.icon
                {
                    if let url = URL(string: values){
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.image = image
                                    addImage(id: link.id, title: cached.title!, stitle: str, image: image, value: db)
                                    funct()
                                }
                            }
                        }
                    }
                }
                else if let values = cached.image
                {
                    if let url = URL(string: values){
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.image = image
                                    addImage(id: link.id, title: cached.title!, stitle: str, image: image, value: db)
                                    funct()
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // Perform preview otherwise
            self.preview?.cancel()
            self.preview = slp.preview(link.url,
          onSuccess: { result in
                self.title = result.title
                let str:String = result.description ?? "No Preview About This URL"
                self.detaille = str
                DispatchQueue.global().async { [weak self] in
                    if let values = result.icon
                    {
                        if let url = URL(string: values){
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.image = image
                                        addImage(id: link.id, title: result.title!, stitle: str, image: image, value: db)
                                        print("ok12")
                                        funct()
                                    }
                                }
                            }
                        }
                    }
                    else if let values = result.image
                    {
                        if let url = URL(string: values){
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.image = image
                                        addImage(id: link.id, title: result.title!, stitle: str, image: image, value: db)
                                        funct()
                                    }
                                }
                            }
                        }
                    }
                }
                                },
                                      onError: { error in print("<zzz \(error)")})
        }
    }
    
    func load (link:String){
        if let cached = self.slp.cache.slp_getCachedResponse(url: link) {
            self.title = cached.title
            let str:String = cached.description ?? "No Preview About This URL"
            self.detaille = str
            DispatchQueue.global().async { [weak self] in
                if let values = cached.icon
                {
                    if let url = URL(string: values){
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.image = image
                                }
                            }
                        }
                    }
                }
                else if let values = cached.image
                {
                    if let url = URL(string: values){
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.image = image
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // Perform preview otherwise
            self.preview?.cancel()
            self.preview = slp.preview(link,
          onSuccess: { result in
                self.title = result.title
                let str:String = result.description ?? "No Preview About This URL"
                self.detaille = str
                DispatchQueue.global().async { [weak self] in
                    if let values = result.icon
                    {
                        if let url = URL(string: values){
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.image = image
                                    }
                                }
                            }
                        }
                    }
                    else if let values = result.image
                    {
                        if let url = URL(string: values){
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.image = image
                                    }
                                }
                            }
                        }
                    }
                }
                                },
                                      onError: { error in print("<zzz \(error)")})
        }
        
    }
}
class LinkViewModel : ObservableObject {
    let metadataProvider = LPMetadataProvider()
    
    @Published var metadata: LPLinkMetadata?
    @Published var image: UIImage?
    
    func load (link : String) {
        guard let url = URL(string: link) else {
            return
        }
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            guard error == nil else {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.metadata = metadata
            }
            guard let imageProvider = metadata?.imageProvider else { return }
            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard error == nil else {
                    // handle error
                    print(error!)
                    return
                }
                if let image = image as? UIImage {
                    // do something with image
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("no image available")
                }
            }
        }
    }
    func loadData (link : String) {
        guard let url = URL(string: link) else {
            return
        }
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            guard error == nil else {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.metadata = metadata
            }
            guard let imageProvider = metadata?.imageProvider else { return }
            imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard error == nil else {
                    // handle error
                    print(error!)
                    return
                }
                if let image = image as? UIImage {
                    // do something with image
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("no image available")
                }
            }
        }
    }
}

class mycolors : ObservableObject {
    @Published var colors:[String] = ["color0","color1","color2","color3","color4","color5","color6","color7","color8","color9"]
    @Published var Collections :[collection] = []
    @Published var Trash :[Books] = []
    @Published var selected:Int = -2;
    
    var cache = NSCache<NSString, UIImage>()
    var value:myDatabase
    let network: NetworkManager = NetworkManager.sharedInstance

    init () throws
    {
        do{
            value = try myDatabase()
            
            reload()
            NetworkManager.isReachable { _ in
                self.reloading()
                self.reload()
            }
        }
        catch let error as NSError {
            throw error
        }
    }
    func addCategorie (title:String,color:Int){
        //Collections.append(collection(id: Collections.count, title: title, color: color))
        value.insertCollection(item: collection(id: Collections.count, title: title, color: color))
        reload()
    }
    
    func UpdateCategorie (title:String,color:Int,id:Int){
        //Collections.append(collection(id: Collections.count, title: title, color: color))
        value.updateCategorie(item: collection(id: id, title: title, color: color))
        reload()
    }
    
    func reloading(){
        let a = value.updatablItems()
        let link = PreviwLinkCustom()
        a.forEach { value in
            print(value.url)
            link.loadurl(link: value, db: self.value, funct: reload)
        }
    }
    func reload(){
        value.deleteWhere()
        Collections = []
        Collections.append(contentsOf: value.LoadCollection())
        getTrash()
        //print(Collections)
    }
    func getTrash(){
        let val = value.LoadDeleted()
        Trash = []
        for v in val {
            if let image = UserDefaults.standard.url(forKey: v.icon)
            {
                Trash.append(Books(id: v.id, link: v.link, title: v.title, detaille: v.detaille, icon: UIImage(contentsOfFile: image.path)!,date: v.date))
            }
        }
    }
    func getAll () -> [Books]{
        
        var all:[Books] = []
        
        var check = -1
        for it in Collections {
            for item in it.urls {
                check = all.firstIndex(where: {$0.link == item.link}) ?? -1
                //print(check)
                if(check == -1){
                    if let image = UserDefaults.standard.url(forKey: item.icon)
                    {
                        all.append(Books(id: item.id,link: item.link, title: item.title, detaille: item.detaille,favorit: item.favorit, icon: UIImage(contentsOfFile: image.path)!,disabled: true))
                    }
                }
            }
        }
        return all
    }
    
    func getAllFavorite () -> [Books]{
        
        var all:[Books] = []
        
        
        for it in Collections {
            for item in it.urls {
                if(item.favorit){
                    if let image = UserDefaults.standard.url(forKey: item.icon)
                    {
                        all.append(Books(id: item.id,link: item.link, title: item.title, detaille: item.detaille,favorit: item.favorit, icon: UIImage(contentsOfFile: image.path)!))
                    }
                }
            }
        }
        return all
    }
    
    func getCategorie (index: Int) -> CollectionsItem {
        //print(index)
        let col = Collections[index]
        var all:[Books] = []
        for item in col.urls {
            if let image = UserDefaults.standard.url(forKey: item.icon)
            {
                all.append(Books(id: item.id,link: item.link, title: item.title, detaille: item.detaille,favorit: item.favorit, icon: UIImage(contentsOfFile: image.path)!))
            }
            else
            {
                print(item)
            }
        }
        let collections = CollectionsItem(id: col.id, title: col.title, color: col.color , urls: all)
        return collections
    }
    func getCategorieById (index: Int) -> CollectionsItem {
        //print(index)
        let col = Collections.first(where: {$0.id == index})
        var all:[Books] = []
        for item in col!.urls {
            if let image = UserDefaults.standard.url(forKey: item.icon)
            {
                all.append(Books(id: item.id,link: item.link, title: item.title, detaille: item.detaille,favorit: item.favorit, icon: UIImage(contentsOfFile: image.path)!))
            }
            else
            {
                print(item)
            }
        }
        let collections = CollectionsItem(id: col!.id, title: col!.title, color: col!.color , urls: all)
        return collections
    }
    
    func addToCategorie(link:String , title:String,detaille:String,image:UIImage,favorit:Bool = false ,id:[Int]){
        
        let icon = UUID().uuidString;

        // Convert to Data
        if let data = image.pngData() {
            // Create URL
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent(icon)

            do {
                // Write to Disk
                try data.write(to: url)
                
                // Store URL in User Defaults
                UserDefaults.standard.set(url, forKey: icon)
                value.insertLink(item: LinkesItems(id: -1, link: link, title: title, detaille: detaille,favorit: favorit, icon: icon), id: id)
                reload()
                
            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
       
    }
    
    
    func RemoveFromCategorie(id:Int){
        value.removeLink(id: id)
        reload()
    }
    
    func UnRemoveFromCategorie(id:Int){
        value.undeleteItem(id: id)
        reload()
    }
    
    func RemoveCategorie(id:Int){
        value.removeCollection(id: id)
        reload()
    }
    
    func update(item:LinkesItems){
        value.updateLink(item: item)
        reload()
    }
    func FavoriteCategorie(id:Int){
        value.favorit(id: id)
        reload()
    }
    
}


struct collection :Identifiable {
    var id:Int;
    var title :String
    var color:Int
    var urls:[LinkesItems] = []
    var offset:CGFloat = 0
}

struct LinkesItems :Identifiable {
    var id:Int;
    var link:String
    var title :String
    var detaille:String
    var favorit:Bool = false
    var icon:String
    var date:Date = Date()
}

struct CollectionsItem :Identifiable {
    var id:Int;
    var title :String
    var color:Int
    var urls:[Books] = []
    var offset:CGFloat = 0
}

struct Books :Identifiable {
    var id:Int;
    var link:String
    var title :String
    var detaille:String
    var favorit:Bool = false
    var icon:UIImage
    var disabled:Bool = false
    var date:Date = Date()
}

struct MetadataView : View {
    @StateObject var vm : LinkViewModel
    
    var body: some View {
        VStack {
            if let metadata = vm.metadata {
                Text(metadata.title ?? "")
            }
            if let uiImage = vm.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
    }
}

struct Itemurl{
    var id:Int
    var url:String
}
