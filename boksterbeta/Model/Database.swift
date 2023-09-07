//
//  Database.swift
//  Bookmarks
//
//  Created by ziko on 3/2/2022.
//

import SQLite
import SwiftUI

class myDatabase{
    var db : Connection
    
    init() throws {
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            self.db = try Connection("\(path)/database.sqlite3")
            
            let id = Expression<Int64>("id")
            let colid = Expression<Int64>("colid")
            let title = Expression<String>("title")
            let color = Expression<Int>("color")
            let isFirst = Expression<Bool>("isFirst")
            let params = Table("params")

            let collections = Table("collections")
            
            try db.run(collections.create(ifNotExists:true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title, unique: true)
                t.column(color)
            })
            
            let links = Table("links")
            
            try db.run(params.create(ifNotExists:true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(isFirst,defaultValue: false)
            })
            
            let url = Expression<String>("url")
            let detaille = Expression<String>("detaille")
            let icon = Expression<String>("icon")
            let type = Expression<Bool>("favorite")
            let iS = Expression<Bool>("isdeleted")
            let deleted = Expression<Date?>("deleted")
            try db.run(links.create(ifNotExists:true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(url)
                t.column(deleted,defaultValue: Date())
                t.column(iS,defaultValue: false)
                t.column(detaille)
                t.column(icon)
                t.column(type,defaultValue: false)
                t.column(colid)
                t.foreignKey(colid, references: collections, id, delete: .cascade)
            })
            let count = try db.scalar(params.count)
            //let count = try db.scalar(links.count)
            if( count == 0)
            {
                do{
                    try db.run(collections.insert(id<-0,title<-"Default",color<-4))
                    try db.run(collections.insertMany(or: .replace, [title<-"Personal",color<-0], [title<-"Activities",color<-9], [title<-"Work",color<-3], [title<-"Exercices",color<-6], [title<-"Coding",color<-1]))
                    try db.run(params.insert(isFirst<-true))
                }
            }

        }
        catch let error as NSError {
            throw error
        }
    }
    func updatablItems() -> [Itemurl]{
        
        let links = Table("links")
        
        let id = Expression<Int>("id")
        
        let title = Expression<String>("title")
        let detaille = Expression<String>("detaille")
        let icon = Expression<String>("icon")
        let link = Expression<String>("url")

        var items:[Itemurl] = []
        
        do {
            let query = links.filter(title == "" || detaille == "" || icon == "" )
            
            let rowIterator = Array(try db.prepare(query))
            for value in rowIterator {
                let lik =  Int(value[id])
                let url =  value[link]
                items.append(Itemurl(id: lik, url: url))
            }
            return items
        }
        catch {
            return items
        }
    }
    func insertCollection(item : collection){
        
        let collections = Table("collections")
        let title = Expression<String>("title")
        let color = Expression<Int>("color")
        do {
            try db.run(collections.insert(title<-item.title,color<-item.color))
        }
        catch{
            
        }
    }
    
    func removeLink(id:Int){
        let idx = Expression<Int>("id")
        let link = Table("links").filter(idx == id)
        let iS = Expression<Bool>("isdeleted")
        let deleted = Expression<Date>("deleted")

        do {
            try db.run(link.update(iS<-true,deleted<-Date()))
        }
        catch{
            
        }
    }
    func removeCollection(id:Int){
        let idx = Expression<Int>("id")
        let link = Table("collections").filter(idx == id)
        do {
            try db.run(link.delete())
        }
        catch{
            
        }
    }
    func updateLink(item:LinkesItems) {
        let idx = Expression<Int>("id")
        
        let title = Expression<String>("title")
        let detaille = Expression<String>("detaille")
        
        let link = Table("links").filter(idx == item.id)
        do {
            try db.run(link.update(title<-item.title,detaille<-item.detaille))
        }
        catch{
            
        }
    }
    
    func updateLinkFull(item:LinkesItems) {
        let idx = Expression<Int>("id")
        
        let title = Expression<String>("title")
        let detaille = Expression<String>("detaille")
        let icon = Expression<String>("icon")

        let link = Table("links").filter(idx == item.id)
        do {
            try db.run(link.update(title<-item.title,detaille<-item.detaille,icon<-item.icon))
        }
        catch{
            
        }
    }
    
    func updateCategorie(item:collection) {
        
        let idx = Expression<Int>("id")
        
        let collections = Table("collections").filter(idx == item.id)
        
        let title = Expression<String>("title")
        let color = Expression<Int>("color")
        
        do {
            try db.run(collections.update(title<-item.title,color<-item.color))
        }
        catch{
            
        }
    }
    
    func undeleteItem(id:Int) {
        let idx = Expression<Int>("id")
        
        let iS = Expression<Bool>("isdeleted")

        let link = Table("links").filter(idx == id)
        do {
            try db.run(link.update(iS<-false))
        }
        catch{
            
        }
    }
    
    
    func favorit(id:Int) {
        let idx = Expression<Int>("id")
        let link = Table("links").filter(idx == id)
        let type = Expression<Bool>("favorite")
        print("ok")
        do {
            try db.run(link.update(type<-(!type)))
        }
        catch{
            
        }

    }
    func insertLink(item : LinkesItems,id:[Int]){
        
        let collections = Table("links")
        let title = Expression<String>("title")
        let url = Expression<String>("url")
        let detaille = Expression<String>("detaille")
        let icon = Expression<String>("icon")
        let colid = Expression<Int64>("colid")
        let type = Expression<Bool>("favorite")
        
        var arr:[[Setter]]  = []
        for v in id
        {
            arr.append([title<-item.title,url<-item.link,detaille<-item.detaille,type<-item.favorit,icon<-item.icon,colid<-Int64(v)])
        }
        do {
            try db.run(collections.insertMany(arr))
        }
        catch {
            print(error)
        }
    }
    func LoadDeleted() ->[LinkesItems]{
        let links = Table("links")
        
        
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        
        let url = Expression<String>("url")
        let detaille = Expression<String>("detaille")
        let icon = Expression<String>("icon")
        let type = Expression<Bool>("favorite")
        let iS = Expression<Bool>("isdeleted")
        let time = Expression<Date>("deleted")

        var items:[LinkesItems] = []
        
        do {
            let query = links.filter(iS == true)
            
            let rowIterator = Array(try db.prepare(query))
            for value in rowIterator {
                let lik = LinkesItems(id: Int(value[id]), link: value[url], title: value[title], detaille: value[detaille],favorit:  value[type], icon: value[icon],date: value[time])
                items.append(lik)
            }
            return items
        }
        catch{
            return items
        }
    }
    
    func deleteWhere() {
        let links = Table("links")
        let date = Calendar.current.date(byAdding: .month, value: -1,to: Date())
        let deleted = Expression<Date>("deleted")
        let iS = Expression<Bool>("isdeleted")
        let query = links.filter(iS == true && deleted < date!)
        do {
            try db.run(query.delete())
        }
        catch {
            print(error)
        }
    }
    func LoadCollection() -> [collection]{
        let collections = Table("collections")
        let links = Table("links")
        
        
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        let color = Expression<Int>("color")
        
        let url = Expression<String>("url")
        let detaille = Expression<String>("detaille")
        let icon = Expression<String?>("icon")
        let colid = Expression<Int64>("colid")
        let type = Expression<Bool>("favorite")
        let iS = Expression<Bool?>("isdeleted")

        var items:[collection] = []
        
        do {
            let query = collections.join(.leftOuter,links, on: collections[id] == links[colid]).filter(iS == false || iS == nil)
            
            let rowIterator = Array(try db.prepare(query))
            for value in rowIterator {
                do {
                    try value.get(links[id])
                    let test = items.firstIndex(where: { $0.id == value[collections[id]] })
                    
                    let lik = LinkesItems(id: Int(value[links[id]]), link: value[links[url]], title: value[links[title]], detaille: value[links[detaille]],favorit:  value[links[type]], icon: value[links[icon]] as! String)
                    
                    if(test == nil)
                    {
                        items.append(collection(id: Int(value[collections[id]]), title:  value[collections[title]], color: Int(value[collections[color]]),urls: [lik]))
                    }
                    else
                    {
                        items[test!].urls.append(lik)
                    }
                } catch {
                    items.append(collection(id: Int(value[collections[id]]), title:  value[collections[title]], color: Int(value[collections[color]])))
                }
            }
            return items
        }
        catch{
            return items
        }
    }
}
