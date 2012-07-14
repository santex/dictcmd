use strict;
use warnings;
use Test::More 'no_plan';
use feature "say";
use Data::Dumper;


my @test_data = (
"intersection : Schnittpunkt",
"intersection : Zwischenlektion",
"intersections : Schnittpunkte",
"intersection : die Durchdringung",
"intersection [tech.] : der Durchschlag ��[Bergbau]",
"intersection : der Durchschnitt",
"intersection ��- of sets [math.] : der Durchschnitt ��- von Mengen",
"intersection [autom.] : die Einm�ndung ��- Stra�e",
"intersection : der Knotenpunkt",
"intersection : Knotenpunkt in einer Ebene ��[Straßenbau]",
"intersection : der Kreuzpunkt",
"intersection : die Kreuzung ��[Straßenbau]",
"intersection : der Kreuzungspunkt",
"intersection : niveaugleiche Kreuzung ��[Straßenbau]",
"intersection : der Schnitt",
"intersection : die Schnittfläche",
"intersection [tech.] : die Schnittlinie",
"intersection [math.] : die Schnittmenge",
"intersection : der Schnittpunkt",
"intersection [math.] : der Schnittpunkt ��[Geometrie]",
"intersection : die Straßenkreuzung ��[Straßenbau]",
"intersection : der Übergang",
"intersection : die Überschneidung",
"intersection [math.] : Verschneidung von Flächen",
"intersection : die Verzweigung",
"intersection [arch.] : die Vierung ��- Schnittfläche von Mittel- und Querschiff einer Kirche",
"intersection : die Zwischenlektion",
"intersection angle : der Kreuzungswinkel ��- der Verkehrswege ��[Straßenbau]",
"intersection approach : die Kreuzungszufahrt ��[Straßenbau]",
"intersection line [tech.] : die Schnittlinie",
"intersection multiplicity [tech.] : die Schnittmultiplizität",
"intersection of axes [tech.] : die Achsenkreuzung",
"intersection of batter with natural surface [constr.] : der Böschungsfuß",
"intersection of batter with natural surface [constr.] : der Hangfuß ��[Straßenbau]",
"intersection of lodes [tech.] : das Gangkreuz",
"intersection of lodes [tech.] : das Scharkreuz",
"intersection of sets [tech.] : der Mengendurchschnitt",
"intersection of upstream and downstream faces [tech.] : Spitze des theoretischen Dreiecks",
"intersection of welds [tech.] : die Nahtkreuzung ��[Schweißen]",
"intersection pitch [tech.] : der Kreuzungsschritt",
"intersection point : der Kreuzungspunkt",
"intersection point [tech.] : der Schnittpunkt",
"intersection point of the theoretical frog nose [tech.] : theoretischer Herzstückschnittpunkt ��[Eisenbahn]",
"intersection scheme [tech.] : das Schnittschema",
"angle of intersection : der Schnittwinkel",
"area of intersection [autom.] : das Schnittfeld ��- Stoß",
"axis intersection angle [tech.] : der Achsenkreuzungswinkel",
"braided intersection : Kreuzung in mehreren Ebenen ��[Straßenbau]",
"braided intersection : niveaufreie Kreuzung ��[Straßenbau]",
"clover-leaf intersection : das Kleeblatt ��[Straßenbau]",
"clover-leaf intersection : die Kleeblattkreuzung ��[Straßenbau]",
"compound intersection : vielarmige Kreuzung ��[Straßenbau]",
"four-way intersection : vierarmige Kreuzung ��[Straßenbau]",
"glancing intersection [tech.] : schleifender Schnitt",
"grade-separated intersection : Kreuzung in zwei oder mehr Ebenen ��[Straßenbau]",
"grade-separated intersection : niveaufreie Kreuzung ��[Straßenbau]",
"hydraulic longitudinal intersection : hydraulischer Längenschnitt ��[Abwasser]",
"line of intersection [math.] : die Schnittgerade",
"line of intersection [tech.] : die Schnittlinie",
"longitudinal intersection : der Längenschnitt",
"multiple bridge intersection : Kreuzung in mehreren Ebenen ��[Straßenbau]",
"multiple bridge intersection : niveaufreie Kreuzung ��[Straßenbau]",
"multiple intersection : vielarmige Kreuzung ��[Straßenbau]",
"multiway intersection : vielarmige Kreuzung ��[Straßenbau]",
"pipe intersection [tech.] : die Rohrüberschneidung",
"point of intersection : der Knotenpunkt",
"point of intersection : der Kreuzungspunkt",
"point of intersection : der Schnittpunkt",
"point of intersection of the L.W. loci [tech.] : Schnittpunkt des geometrischen Ortes von Springniedrigwasser mit dem geometrischen Ort von Nippniedrigwasser",
"rhomboid-intersection method [autom.] : das Rhomboid-Schnitt-Verfahren",
"rotary intersection (Amer.) : der Kreiselplatz (Schweiz)",
"rotary intersection (Amer.) : der Kreisplatz",
"rotary intersection (Amer.) : der Kreisverkehrsplatz",
"rotary intersection (Amer.) : der Verkehrskreisel",
"rotary intersection (Amer.) : der Verteilerring",
"roundabout intersection : der Kreisverkehrsplatz",
"skew intersection : schiefwinklige Kreuzung ��[Straßenbau]",
"T intersection (Amer.) : dreiarmiger Knotenpunkt ��[Straßenbau]",
"T intersection (Amer.) : rechtwinklige Straßeneinmündung ��[Straßenbau]",
"T intersection (Amer.) : T-förmige Kreuzung ��[Straßenbau]",
"T-intersection : rechtwinklige Kreuzung ��[Straßenbau]",
"T-intersection : T-förmige Kreuzung ��[Straßenbau]",
"three-way intersection : dreiarmiger Knotenpunkt ��[Straßenbau]",
"three-way intersection : rechtwinklige Straßeneinmündung ��[Straßenbau]",
"three-way intersection : T-förmige Kreuzung ��[Straßenbau]",
"track-switch intersection point [tech.] : der Weichenschnittpunkt ��[Eisenbahn]",
"urban intersection (Amer.) : städtischer Knotenpunkt",
"Y intersection (Amer.) : schiefwinklige Straßeneinmündung ��[Straßenbau]",
"Y intersection (Amer.) : schiefwinklige Straßengabelung ��[Straßenbau]",
"Y intersection (Amer.) : die Y-Kreuzung ��[Straßenbau]",
"intersection-free �adj. : kreuzungsfrei",
);

my @test = (
"intersection : der Kreuzungspunkt",
"intersection : der Schnitt",
"intersection : die Schnittfläche",
"intersection [tech.] : die Schnittlinie",
"intersection [math.] : die Schnittmenge",
"intersection : der Schnittpunkt",
"hydraulic longitudinal intersection : hydraulischer Längenschnitt ��[Abwasser]",
"intersection [autom.] : die Einm�ndung ��- Stra�e",
"T intersection (Amer.) : dreiarmiger Knotenpunkt ��[Stra�enbau]",
"T-intersection : rechtwinklige Kreuzung ��[Stra�enbau]",
"track-switch intersection point : der Weichenschnittpunkt ��[Eisenbahn]",
);

sub pretty_printer(\@)
{
    my $su = sub { s/(?:\[.*?\])//g; s/(?:\-\s.*?\:??)//g; s/(?:\(.*?\))//g;
        s/\s{2,}/ /g; $_;};
    map { $su->($_) } @{shift()};
}


pretty_printer(@test_data);

#for my $j ( 0 .. $#test_data ) {
#    say $test_data[$j];
#}

our $term = 'intersection';

sub sort_precise(\@) 
{
    my @list = @{ shift() };
    @list = sort { length($a) <=> length($b) } @list;
    return @list;
}

my @result = sort_precise(@test_data);
say Dumper($_) for (@result);

