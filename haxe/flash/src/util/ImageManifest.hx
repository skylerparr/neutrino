package util;
#if macro
import haxe.macro.Context;
import haxe.crypto.Md5;
import sys.io.File;
import sys.FileSystem;
import sys.FileSystem;
import haxe.macro.Expr;
#end
import haxe.macro.Expr;
class ImageManifest {
    public function new() {
    }

    macro public static function getManifestAuthority(): Expr {
        var items: Array<String> = [];
        var mainPath: String = "Assets/";
        #if ios
        mainPath = Context.resolvePath(mainPath);
        #end
        getAllSVGPaths(items, mainPath);
        var regx: EReg = ~/(\/)|(\s)|(\.)/g;
        var allSymbolsAndSVGS: Map<String, String> = new Map();
        for(item in items) {
            var dataString: String = File.getContent(item);
            var svg: Xml = Xml.parse(dataString);
            #if ios
            item = regx.replace(StringTools.replace(item, Context.resolvePath("assets/"), "assets/"), "_");
            #else
            item = regx.replace(item, "_");
            #end
            var cacheId: String = Md5.encode(dataString);
            allSymbolsAndSVGS.set(item, cacheId);
            for(child in svg.firstElement().iterator()) {
                if(child.nodeType != Xml.Element) {
                    continue;
                }
                if(child.nodeName == "symbol") {
                    var vb: String = child.get("viewBox");
                    if(vb != null) {
                        var frags: Array<String> = vb.split(" ");
                        child.set("width", frags[2] + "px");
                        child.set("height", frags[3] + "px");
                    }
                    var svgData: String = child.toString();
                    svgData = StringTools.replace(svgData, "<symbol", "<svg");
                    svgData = StringTools.replace(svgData, "</symbol", "</svg");
                    var id: String = child.get("id");
                    var cacheId: String = Md5.encode(svgData);
                    allSymbolsAndSVGS.set(id, cacheId);
                }
            }
        }
        var output: Array<Field> = [];
        for(item in allSymbolsAndSVGS.keys()) {
            var tString = TPath({pack: [], name: "String", params: [], sub: null});
            output.push({name: regx.replace(item, "_"), pos: Context.currentPos(), meta: null, kind: FieldType.FVar(tString, Context.parse("'" + allSymbolsAndSVGS.get(item) + "'", Context.currentPos())), doc: null, access: [Access.APublic]});
        }
        output.push({
            name: "new",
            access: [APublic],
            pos: Context.currentPos(),
            kind: FFun({
                args: [],
                expr: Context.parse("null", Context.currentPos()),
                params: [],
                ret: null
            })
        });

        var type: TypeDefinition = {pos: Context.currentPos(), params: [], pack: [], name: "Manifest", meta: [], kind: TypeDefKind.TDClass(null, null, false), isExtern: false, fields: output};
        Context.defineType(type);
        return Context.parse("new Manifest()", Context.currentPos());
    }

    #if macro
    public static function getAllSVGPaths(items: Array<String>, directory: String): Void {
        var dirItems: Array<String> = FileSystem.readDirectory(directory);
        for(dirItem in dirItems) {
            if(FileSystem.isDirectory(directory + dirItem)) {
                getAllSVGPaths(items, directory + dirItem + "/");
            } else {
                if(StringTools.endsWith(dirItem, ".svg")) {
                    items.push(directory + dirItem);
                }
            }
        }
    }
    #end
}
