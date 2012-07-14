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
"intersection [tech.] : der Durchschlag   [Bergbau]",
"intersection : der Durchschnitt",
"intersection   - of sets [math.] : der Durchschnitt   - von Mengen",
"intersection [autom.] : die Einmündung   - Straße",
"intersection : der Knotenpunkt",
"intersection : Knotenpunkt in einer Ebene   [StraÃŸenbau]",
"intersection : der Kreuzpunkt",
"intersection : die Kreuzung   [StraÃŸenbau]",
"intersection : der Kreuzungspunkt",
"intersection : niveaugleiche Kreuzung   [StraÃŸenbau]",
"intersection : der Schnitt",
"intersection : die SchnittflÃ¤che",
"intersection [tech.] : die Schnittlinie",
"intersection [math.] : die Schnittmenge",
"intersection : der Schnittpunkt",
"intersection [math.] : der Schnittpunkt   [Geometrie]",
"intersection : die StraÃŸenkreuzung   [StraÃŸenbau]",
"intersection : der Ãœbergang",
"intersection : die Ãœberschneidung",
"intersection [math.] : Verschneidung von FlÃ¤chen",
"intersection : die Verzweigung",
"intersection [arch.] : die Vierung   - SchnittflÃ¤che von Mittel- und Querschiff einer Kirche",
"intersection : die Zwischenlektion",
"intersection angle : der Kreuzungswinkel   - der Verkehrswege   [StraÃŸenbau]",
"intersection approach : die Kreuzungszufahrt   [StraÃŸenbau]",
"intersection line [tech.] : die Schnittlinie",
"intersection multiplicity [tech.] : die SchnittmultiplizitÃ¤t",
"intersection of axes [tech.] : die Achsenkreuzung",
"intersection of batter with natural surface [constr.] : der BÃ¶schungsfuÃŸ",
"intersection of batter with natural surface [constr.] : der HangfuÃŸ   [StraÃŸenbau]",
"intersection of lodes [tech.] : das Gangkreuz",
"intersection of lodes [tech.] : das Scharkreuz",
"intersection of sets [tech.] : der Mengendurchschnitt",
"intersection of upstream and downstream faces [tech.] : Spitze des theoretischen Dreiecks",
"intersection of welds [tech.] : die Nahtkreuzung   [SchweiÃŸen]",
"intersection pitch [tech.] : der Kreuzungsschritt",
"intersection point : der Kreuzungspunkt",
"intersection point [tech.] : der Schnittpunkt",
"intersection point of the theoretical frog nose [tech.] : theoretischer HerzstÃ¼ckschnittpunkt   [Eisenbahn]",
"intersection scheme [tech.] : das Schnittschema",
"angle of intersection : der Schnittwinkel",
"area of intersection [autom.] : das Schnittfeld   - StoÃŸ",
"axis intersection angle [tech.] : der Achsenkreuzungswinkel",
"braided intersection : Kreuzung in mehreren Ebenen   [StraÃŸenbau]",
"braided intersection : niveaufreie Kreuzung   [StraÃŸenbau]",
"clover-leaf intersection : das Kleeblatt   [StraÃŸenbau]",
"clover-leaf intersection : die Kleeblattkreuzung   [StraÃŸenbau]",
"compound intersection : vielarmige Kreuzung   [StraÃŸenbau]",
"four-way intersection : vierarmige Kreuzung   [StraÃŸenbau]",
"glancing intersection [tech.] : schleifender Schnitt",
"grade-separated intersection : Kreuzung in zwei oder mehr Ebenen   [StraÃŸenbau]",
"grade-separated intersection : niveaufreie Kreuzung   [StraÃŸenbau]",
"hydraulic longitudinal intersection : hydraulischer LÃ¤ngenschnitt   [Abwasser]",
"line of intersection [math.] : die Schnittgerade",
"line of intersection [tech.] : die Schnittlinie",
"longitudinal intersection : der LÃ¤ngenschnitt",
"multiple bridge intersection : Kreuzung in mehreren Ebenen   [StraÃŸenbau]",
"multiple bridge intersection : niveaufreie Kreuzung   [StraÃŸenbau]",
"multiple intersection : vielarmige Kreuzung   [StraÃŸenbau]",
"multiway intersection : vielarmige Kreuzung   [StraÃŸenbau]",
"pipe intersection [tech.] : die RohrÃ¼berschneidung",
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
"skew intersection : schiefwinklige Kreuzung   [StraÃŸenbau]",
"T intersection (Amer.) : dreiarmiger Knotenpunkt   [StraÃŸenbau]",
"T intersection (Amer.) : rechtwinklige StraÃŸeneinmÃ¼ndung   [StraÃŸenbau]",
"T intersection (Amer.) : T-fÃ¶rmige Kreuzung   [StraÃŸenbau]",
"T-intersection : rechtwinklige Kreuzung   [StraÃŸenbau]",
"T-intersection : T-fÃ¶rmige Kreuzung   [StraÃŸenbau]",
"three-way intersection : dreiarmiger Knotenpunkt   [StraÃŸenbau]",
"three-way intersection : rechtwinklige StraÃŸeneinmÃ¼ndung   [StraÃŸenbau]",
"three-way intersection : T-fÃ¶rmige Kreuzung   [StraÃŸenbau]",
"track-switch intersection point [tech.] : der Weichenschnittpunkt   [Eisenbahn]",
"urban intersection (Amer.) : stÃ¤dtischer Knotenpunkt",
"Y intersection (Amer.) : schiefwinklige StraÃŸeneinmÃ¼ndung   [StraÃŸenbau]",
"Y intersection (Amer.) : schiefwinklige StraÃŸengabelung   [StraÃŸenbau]",
"Y intersection (Amer.) : die Y-Kreuzung   [StraÃŸenbau]",
"intersection-free  adj. : kreuzungsfrei",
);

my @test = (
"intersection : der Kreuzungspunkt",
"intersection : der Schnitt",
"intersection : die SchnittflÃ¤che",
"intersection [tech.] : die Schnittlinie",
"intersection [math.] : die Schnittmenge",
"intersection : der Schnittpunkt",
"hydraulic longitudinal intersection : hydraulischer LÃ¤ngenschnitt   [Abwasser]",
"intersection [autom.] : die Einmündung   - Straße",
"T intersection (Amer.) : dreiarmiger Knotenpunkt   [Straßenbau]",
"T-intersection : rechtwinklige Kreuzung   [Straßenbau]",
"track-switch intersection point : der Weichenschnittpunkt   [Eisenbahn]",
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

