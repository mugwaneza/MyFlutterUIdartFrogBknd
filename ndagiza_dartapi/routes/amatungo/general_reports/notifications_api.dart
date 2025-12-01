
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';

// Helper function to format dates
String? _formatDate(dynamic date) {
  if (date == null) return null;
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
Future<Response> onRequest(RequestContext context) async {
  final result = await db.query('''
   SELECT 
    ----------- itungo table
    i.itunguui,                     
    i.itunguui_imyruui,             
    i.igitsina,                     
    i.ibara,                        
    i.ifoto_url,                    
    i.ubukure,                      
    i.itngcode,                     
    i.ibiro,                        
    i.ahoryavuye,                   
    i.igihe,                        

    ----------- itungo_ukozororoka_abashumba (uab)
    uab.ukozruui,                    
    uab.amezi_rihaka,                
    uab.itariki_ryimiye,             
    uab.itariki_ribyariye,           
    uab.itariki_ariherewe,           
    uab.itariki_aryakiwe,            
    uab.igitsina_cyavutse,           

    ----------- itungo_ubuzimabwaryo (ub)
    ub.uzmuui,                       
    ub.amafaranga_yarigiyeho,        
    ub.amafaranga_ryinjije,          
    ub.ibisobanuro,                  
    ub.itariki_byabereyeho,          

    ----------- itungo_isokoryaryo (iso)
    iso.amafaranga_rihagaze,         
    iso.itariki_byabereyeho AS itariki_yaguriwe,
    iso.iskuui,                      

    ----------- imyororokere (imyr)
    imyr.ubwokobwitungo,             
    imyr.ameziibyarira,              
    imyr.imyakayokororoka,           

    ----------- abashumba - abishingizi (linked via uab)
    abshu.izina_ryababyeyi AS izina_uhagarariye,
    abshu.izina_rindi AS irindi_zina_uhagarariye,
    abshu.tel1 AS telephone_uhagarariye,
    abshu.icyo_ashinzwe AS inshingano_uhagarariye,
    abshu.ahoatuye AS aho_atuye_uhagarariye,

    ----------- aborozi (owner)
    abshu2.izina_ryababyeyi AS izina_uworoye,
    abshu2.izina_rindi AS irindi_zina_uworoye,
    abshu2.tel1 AS telephone_uworoye,
    abshu2.icyo_ashinzwe AS inshingano_uworoye,
    abshu2.ahoatuye AS aho_atuye_uworoye

    FROM amatungo.itungo i
    INNER JOIN amatungo.itungo_ukozororoka_abashumba uab
      ON i.itunguui = uab.itunguui
    INNER JOIN amatungo.itungo_ubuzimabwaryo ub
      ON i.itunguui = ub.itunguui
    INNER JOIN amatungo.itungo_isokoryaryo iso
      ON i.itunguui = iso.itunguui
    INNER JOIN amatungo.imyororokere imyr
      ON i.itunguui_imyruui = imyr.imyruui
    INNER JOIN aborozi.abashumba abshu
      ON uab.abshuui_uhagariy = abshu.abshuui
    INNER JOIN aborozi.abashumba abshu2
      ON uab.abshuui_umworoz = abshu2.abshuui
    WHERE uab.seqno = (
        SELECT MAX(seqno)
        FROM amatungo.itungo_ukozororoka_abashumba
        WHERE itunguui = i.itunguui
    )
    AND ub.seqno = (
        SELECT MAX(seqno)
        FROM amatungo.itungo_ubuzimabwaryo
        WHERE itunguui = i.itunguui
    )
    AND iso.seqno = (
        SELECT MAX(seqno)
        FROM amatungo.itungo_isokoryaryo
        WHERE itunguui = i.itunguui
    )
    '''
    );

  //  Map each row to JSON
  final data = result.map((row) => {
    'itunguui': row[0],
    'itunguui_imyruui': row[1],
    'igitsina': row[2],
    'ibara': row[3],
    'ifoto_url': row[4],
    'ubukure': row[5],
    'itngcode': row[6],
    'ibiro': row[7],
    'ahoryavuye': row[8],
    'igihe': _formatDate(row[9]),

    'ukozruui': row[10],
    'amezi_rihaka': row[11],
    'itariki_ryimiye': _formatDate(row[12]),
    'itariki_ribyariye': _formatDate(row[13]),
    'itariki_ariherewe': _formatDate(row[14]),
    'itariki_aryakiwe': _formatDate(row[15]),
    'igitsina_cyavutse': row[16],

    'uzmuui': row[17],
    'amafaranga_yarigiyeho': row[18],
    'amafaranga_ryinjije': row[19],
    'ibisobanuro': row[20],
    'itariki_byabereyeho': _formatDate(row[21]),

    'amafaranga_rihagaze': row[22],
    'itariki_yaguriwe': _formatDate(row[23]),
    'iskuui': row[24],

    'ubwokobwitungo': row[25],
    'ameziibyarira': row[26],
    'imyakayokororoka': row[27],

    'izina_uhagarariye': row[28],
    'irindi_zina_uhagarariye': row[29],
    'telephone_uhagarariye': row[30],
    'inshingano_uhagarariye': row[31],
    'aho_atuye_uhagarariye': row[32],

    'izina_uworoye': row[33],
    'irindi_zina_uworoye': row[34],
    'telephone_uworoye': row[35],
    'inshingano_uworoye': row[36],
    'aho_atuye_uworoye': row[37],
  }).toList();

  return Response.json(body: data);

}

