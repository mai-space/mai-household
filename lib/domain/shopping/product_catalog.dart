import 'departments.dart';

/// Mitgeliefertes Wörterbuch: Begriff → Abteilung (Deutsch + Englisch).
///
/// Begriffe werden mit `TextNorm.key` normalisiert, Singular/Plural müssen
/// daher nicht doppelt stehen. Zusammengesetzte Wörter („Vollkorntoast“)
/// werden über das Wortende gefunden — deshalb reichen hier die Grundwörter.
/// Reihenfolge innerhalb einer Abteilung ist egal.
const Map<BuiltinDepartment, String> productCatalogSource = {
  BuiltinDepartment.produce:
      'obst|gemüse|apfel|äpfel|birne|banane|orange|mandarine|clementine|'
      'zitrone|limette|grapefruit|kiwi|mango|ananas|melone|wassermelone|'
      'honigmelone|traube|weintraube|erdbeere|himbeere|heidelbeere|blaubeere|'
      'brombeere|johannisbeere|kirsche|pflaume|zwetschge|aprikose|pfirsich|'
      'nektarine|feige|granatapfel|avocado|papaya|maracuja|kokosnuss|beere|'
      'tomate|cherrytomate|rispentomate|gurke|salatgurke|paprika|zucchini|'
      'aubergine|kartoffel|süßkartoffel|zwiebel|rote zwiebel|lauchzwiebel|'
      'frühlingszwiebel|schalotte|knoblauch|ingwer|karotte|möhre|pastinake|'
      'sellerie|staudensellerie|knollensellerie|lauch|porree|brokkoli|'
      'blumenkohl|rosenkohl|weißkohl|rotkohl|wirsing|spitzkohl|grünkohl|'
      'kohlrabi|kohl|spinat|blattspinat|mangold|salat|kopfsalat|eisbergsalat|'
      'feldsalat|rucola|romanasalat|chicorée|radicchio|radieschen|rettich|'
      'rote bete|kürbis|hokkaido|butternut|mais|maiskolben|champignon|pilz|'
      'pfifferling|kräuterseitling|shiitake|petersilie|schnittlauch|'
      'basilikum|koriander|minze|dill|rosmarin|thymian|kresse|kräuter|'
      'spargel|bohne|grüne bohne|erbse|zuckerschote|fenchel|artischocke|'
      'okra|chili|peperoni|jalapeño|rhabarber|sprossen|'
      'fruit|vegetable|apple|pear|lemon|lime|grape|strawberry|raspberry|'
      'blueberry|cherry|peach|tomato|cucumber|pepper|potato|onion|garlic|'
      'ginger|carrot|celery|broccoli|cauliflower|cabbage|spinach|lettuce|'
      'mushroom|parsley|basil|herb',
  BuiltinDepartment.bakery:
      'brot|brötchen|semmel|schrippe|weckle|baguette|ciabatta|toast|toastbrot|'
      'vollkornbrot|roggenbrot|mischbrot|dinkelbrot|sauerteigbrot|'
      'pumpernickel|knäckebrot|brezel|breze|laugenbrezel|laugenstange|'
      'croissant|hörnchen|kuchen|torte|muffin|donut|berliner|krapfen|'
      'zwieback|fladenbrot|pita|wrap|tortilla|burgerbrötchen|hotdogbrötchen|'
      'aufbackbrötchen|bread|roll|bun|bagel|baguette',
  BuiltinDepartment.dairy:
      'milch|vollmilch|fettarme milch|hafermilch|mandelmilch|sojamilch|'
      'laktosefreie milch|buttermilch|sahne|schlagsahne|kochsahne|'
      'sauerrahm|saure sahne|schmand|crème fraîche|creme fraiche|quark|'
      'magerquark|joghurt|naturjoghurt|griechischer joghurt|skyr|kefir|'
      'pudding|butter|margarine|käse|gouda|emmentaler|edamer|cheddar|'
      'mozzarella|burrata|feta|hirtenkäse|parmesan|grana padano|camembert|'
      'brie|frischkäse|hüttenkäse|körniger frischkäse|reibekäse|'
      'scheibenkäse|halloumi|mascarpone|ricotta|ei|eier|frühstücksei|'
      'hefe|frischhefe|blätterteig|pizzateig|quiche teig|tofu|'
      'veggie aufschnitt|hummus|milk|cream|yogurt|yoghurt|cheese|egg|'
      'margarine|oat milk',
  BuiltinDepartment.meat:
      'fleisch|hackfleisch|hack|rinderhack|gemischtes hack|rind|rindfleisch|'
      'steak|rumpsteak|entrecôte|gulasch|schwein|schweinefleisch|schnitzel|'
      'kotelett|nacken|filet|braten|hähnchen|hähnchenbrust|hühnchen|huhn|'
      'hähnchenschenkel|chicken wings|pute|putenbrust|putenschnitzel|ente|'
      'lamm|wurst|würstchen|bratwurst|wiener|frankfurter|weißwurst|'
      'currywurst|salami|schinken|kochschinken|rohschinken|'
      'serrano|prosciutto|speck|bacon|leberwurst|leberkäse|fleischkäse|'
      'mortadella|aufschnitt|mett|frikadelle|cevapcici|burger patty|'
      'chorizo|kassler|meat|beef|pork|ham|sausage|turkey|mince',
  BuiltinDepartment.fish:
      'fisch|lachs|räucherlachs|lachsfilet|thunfisch steak|forelle|kabeljau|'
      'seelachs|dorsch|hering|matjes|makrele|sardine|garnele|shrimp|'
      'scampi|krabbe|muschel|miesmuschel|tintenfisch|calamari|'
      'fischstäbchen|surimi|fish|salmon|prawn|tuna steak',
  BuiltinDepartment.frozen:
      'tiefkühl|tk|eis|eiscreme|speiseeis|eis am stiel|tiefkühlpizza|'
      'pizza|pommes|pommes frites|kroketten|rösti|tk gemüse|'
      'tiefkühlgemüse|rahmspinat|kaisergemüse|erbsen tk|tk beeren|'
      'tk kräuter|eiswürfel|frozen|ice cream|fries',
  BuiltinDepartment.pasta:
      'nudel|nudeln|pasta|spaghetti|penne|fusilli|farfalle|tagliatelle|'
      'lasagneplatte|lasagne platten|maccaroni|makkaroni|rigatoni|tortellini|'
      'gnocchi|spätzle|eiernudel|reisnudel|glasnudel|mie nudel|udon|'
      'reis|basmatireis|jasminreis|risottoreis|milchreis|vollkornreis|'
      'couscous|bulgur|quinoa|hirse|linse|rote linse|kichererbse|'
      'polenta|grieß|haferflocke|haferflocken|graupen|noodle|rice|lentil',
  BuiltinDepartment.canned:
      'dose|konserve|dosentomate|gehackte tomate|passierte tomate|passata|'
      'tomatenmark|kidneybohne|weiße bohne|mais dose|thunfisch|'
      'sauerkraut|rotkohl glas|gewürzgurke|essiggurke|cornichon|oliven|'
      'olive|kapern|getrocknete tomate|antipasti|suppe|brühe|gemüsebrühe|'
      'hühnerbrühe|fond|ravioli|eintopf|fertiggericht|instantnudel|'
      'kokosmilch|pesto|tomatensauce|nudelsauce|apfelmus|kompott|'
      'canned|soup|broth|stock|beans|coconut milk',
  BuiltinDepartment.baking:
      'mehl|weizenmehl|dinkelmehl|vollkornmehl|speisestärke|stärke|'
      'zucker|puderzucker|brauner zucker|rohrzucker|vanillezucker|'
      'backpulver|natron|trockenhefe|kakao|backkakao|kuvertüre|'
      'schokotropfen|streusel|zuckerstreusel|gelatine|agar agar|'
      'tortenguss|puddingpulver|mandel|gemahlene mandel|haselnuss|'
      'gemahlene haselnuss|walnuss|rosine|kokosraspel|backmischung|'
      'marzipan|vanille|vanilleschote|flour|sugar|baking powder|cocoa',
  BuiltinDepartment.spices:
      'salz|pfeffer|paprikapulver|curry|currypulver|kurkuma|kreuzkümmel|'
      'kümmel|zimt|muskat|muskatnuss|oregano|chiliflocken|cayennepfeffer|'
      'lorbeer|nelke|gewürz|gewürze|öl|olivenöl|sonnenblumenöl|rapsöl|'
      'sesamöl|kokosöl|essig|balsamico|apfelessig|senf|ketchup|mayonnaise|'
      'mayo|remoulade|grillsauce|bbq sauce|sojasauce|sojasoße|teriyaki|'
      'sriracha|tabasco|worcestersauce|fischsauce|sambal|harissa|'
      'brühwürfel|maggi|würze|salatdressing|dressing|soße|sauce|'
      'salt|pepper|oil|olive oil|vinegar|mustard|spice|soy sauce',
  BuiltinDepartment.breakfast:
      'müsli|granola|cornflakes|haferflocke|porridge|cerealien|frühstücksflocke|'
      'marmelade|konfitüre|gelee|honig|nutella|nussnougatcreme|'
      'erdnussbutter|aufstrich|brotaufstrich|ahornsirup|sirup|'
      'kaffee|kaffeebohne|kaffeepads|kaffeekapsel|kapsel|espresso|'
      'filterkaffee|instantkaffee|tee|grüner tee|schwarzer tee|kräutertee|'
      'früchtetee|pfefferminztee|kakao pulver|trinkschokolade|zwieback|'
      'cereal|jam|honey|peanut butter|coffee|tea',
  BuiltinDepartment.sweets:
      'schokolade|schoki|tafel schokolade|praline|bonbon|gummibärchen|'
      'gummibären|fruchtgummi|lakritz|kaugummi|keks|kekse|plätzchen|'
      'butterkeks|cookie|waffel|riegel|müsliriegel|schokoriegel|'
      'chips|kartoffelchips|tortilla chips|nachos|flips|erdnussflips|'
      'salzstangen|brezeln snack|cracker|popcorn|nüsse|erdnuss|cashew|'
      'studentenfutter|trockenobst|datteln|reiswaffel|chocolate|candy|'
      'cookies|biscuit|snack|crisps|nuts',
  BuiltinDepartment.drinks:
      'wasser|mineralwasser|sprudel|stilles wasser|saft|apfelsaft|'
      'orangensaft|multivitaminsaft|traubensaft|schorle|apfelschorle|'
      'limo|limonade|cola|fanta|sprite|spezi|eistee|energydrink|'
      'tonic|ginger ale|bier|alkoholfreies bier|radler|weizen|pils|wein|'
      'rotwein|weißwein|rosé|sekt|prosecco|champagner|sekt|schnaps|'
      'wodka|gin|rum|whisky|likör|aperol|kasten|getränk|'
      'water|juice|soda|beer|wine',
  BuiltinDepartment.drugstore:
      'shampoo|spülung|duschgel|seife|flüssigseife|handseife|zahnpasta|'
      'zahncreme|zahnbürste|zahnseide|mundspülung|deo|deodorant|'
      'rasierer|rasierklinge|rasierschaum|creme|handcreme|bodylotion|'
      'sonnencreme|lippenpflege|labello|taschentuch|taschentücher|'
      'tempo|tempos|klopapier|toilettenpapier|feuchttücher|wattepad|'
      'wattestäbchen|binden|tampon|tampons|slipeinlage|pflaster|'
      'kopfschmerztablette|ibuprofen|paracetamol|vitamin|haargel|'
      'haarspray|make up|nagellack|kondom|shampoo|toothpaste|'
      'toilet paper|tissues|soap|deodorant',
  BuiltinDepartment.household:
      'spülmittel|geschirrspülmittel|spülmaschinentabs|tabs|klarspüler|'
      'spülmaschinensalz|regeneriersalz|waschmittel|vollwaschmittel|'
      'colorwaschmittel|weichspüler|fleckentferner|allzweckreiniger|'
      'reiniger|badreiniger|wc reiniger|glasreiniger|entkalker|essigreiniger|'
      'scheuermilch|schwamm|spülschwamm|putztuch|mikrofasertuch|lappen|'
      'müllbeutel|müllbeutel bio|mülltüte|gelber sack|küchenrolle|'
      'küchenpapier|alufolie|frischhaltefolie|backpapier|gefrierbeutel|'
      'zip beutel|kerze|teelicht|batterie|glühbirne|leuchtmittel|'
      'streichholz|feuerzeug|grillkohle|servietten|pappteller|'
      'dish soap|detergent|sponge|trash bag|bin bag|paper towel|'
      'aluminium foil|cling film|baking paper|battery',
  BuiltinDepartment.baby:
      'windel|windeln|feuchttücher baby|babybrei|gläschen|babynahrung|'
      'pre milch|folgemilch|schnuller|babyshampoo|wundschutzcreme|'
      'diaper|baby food|formula',
  BuiltinDepartment.pet:
      'katzenfutter|hundefutter|nassfutter|trockenfutter|katzenstreu|'
      'leckerli|kauknochen|vogelfutter|fischfutter|tierfutter|'
      'cat food|dog food|cat litter',
};
