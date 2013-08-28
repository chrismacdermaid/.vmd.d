#       {scale  Guy Privalov    Eisenberg   White_if    White}
#       {ALA    0.100   1     0.620     0.17    0.50}
#       {ARG    1.910   2    -2.530     0.81    1.81}
#       {ASN    0.480   1    -0.780     0.42    0.85}
#       {ASP    0.780   2    -0.900     1.23    3.64}
#       {CYS    -1.420  1     0.290     -0.24   -0.02}
#       {GLY    0.950   2    -0.850     0.58    0.77}
#       {GLU    0.830   1    -0.740     2.02    3.63}
#       {GLN    0.330   2     0.480     0.01    1.15}
#       {HIS    -0.500  1    -0.400     0.96    2.33}
#       {ILE    -1.130  2     1.380     -0.31   -1.12}
#       {LEU    -1.180  1     1.060     -0.56   -1.25}
#       {LYS    1.400   2    -1.500     0.99    2.80}
#       {MET    -1.590  1     0.640     -0.23   -0.67}
#       {PHE    -2.120  2     1.190     -1.13   -1.71}
#       {PRO    0.730   1     0.120     0.45    0.14}
#       {SER    0.520   2    -0.180     0.13    0.46}
#       {THR    0.070   1    -0.050     0.14    0.25}
#       {TRP    -0.510  2     0.810     -1.85   -2.09}
#       {TYR    -0.210  1     0.260     -0.94   -0.71}
#       {VAL    -1.270  2     1.080     0.07    -0.46}

proc bs {args} {
    # Sets beta value of protein residues to the value found in the selected hydrophobicity scale
    if { ![llength $args] } {
        set scale help
    } else {
        set scale $args
    }
    betascale $scale
}

proc betascale {args} {
    if { ![llength $args] } {
        set scale help
    } else {
        if {[llength [lindex $args 0]]>1} {
            set args [lindex $args 0]
        }
        set scale [lindex $args 0]
        if {[llength $args]==2} {
            # Some options provided
            set opt [lindex $args 1]
        } else {
            set opt "none"
        }
    }

    # Sets beta value of protein residues to the value found in the selected hydrophobicity scale
    [atomselect top all] set beta 0

    # Define values for all the hydrophobicity scales
    switch [string tolower $scale] {
        {} -
        {-h} -
        {help} {
            puts {
                _____________________Amino Acid Property Scales:______________________
                AA_Composition  ---Overall amino acid composition (%).  (McCaldon P., Argos P.)
                AA_SwissProt    ---Amino acid composition (%) in the Swiss-Prot Protein Sequence
                data bank.     (Bairoch A.)
                AccessibleResidues  ---Molar fraction (%) of 3220 accessible residues.
                (Janin J.)
                AlphaHelix_Fasman   ---Amino acid scale: Conformational parameter for alpha
                helix (computed from 29 proteins).
                ( Chou P.Y., Fasman G.D.)
                AlphaHelix_Levitt   ---Normalized frequency for alpha helix.
                (Levitt M.)
                AlphaHelix_Roux ---Conformational parameter for alpha helix.
                (Deleage G., Roux B.)
                AntiparallelBetaStrand  ---Conformational preference for antiparallel beta
                strand.     (Lifson S., Sander C.)
                AverageBuried   ---Average area buried on transfer from standard state to folded
                protein.   (Rose G.D., Geselowitz A.R.,
                            Lesser G.J., Lee R.H., Zehfus M.H.)
                AverageFlexibility  ---Average flexibility index.
                (Bhaskaran R., Ponnuswamy P.K.)
                BetaSheet_Fasman    ---Conformational parameter for beta-sheet (computed
                                                                                from 29 proteins).  (Chou P.Y., Fasman G.D.)
                BetaSheet_Levitt    ---Normalized frequency for beta-sheet.
                (Levitt M.)
                BetaSheet_Roux  ---Conformational parameter for beta-sheet.
                (Deleage G., Roux B.)
                BetaTurn_Fasman ---Conformational parameter for beta-turn
                (computed from 29 proteins).    (Chou P.Y., Fasman G.D.)
                BetaTurn_Levitt ---Normalized frequency for beta-turn.  (Levitt M.)
                BetaTurn_Roux   ---Conformational parameter for beta-turn.
                (Deleage G., Roux B.)
                Bulkiness   ---Bulkiness.   (Zimmerman J.M., Eliezer N., Simha R.)
                BuriedResidues  ---Molar fraction (%) of 2001 buried residues.  (Janin J.)
                Coil_Roux   ---Conformational parameter for coil.   (Deleage G., Roux B.)
                Hphob_Argos ---Membrane buried helix parameter.     (Rao M.J.K., Argos P.)
                Hphob_Black ---Amino acid scale: Hydrophobicity of physiological L-alpha
                amino acids     ( Black S.D., Mould D.R.)
                Hphob_Breese    ---Hydrophobicity (free energy of transfer to surface in
                                                   kcal/mole).     (Bull H.B., Breese K.)
                Hphob_Chothia   ---Proportion of residues 95% buried (in 12 proteins).
                (Chothia C.)
                Hphob_Doolittle ---Hydropathicity.  (Kyte J., Doolittle R.F.)
                Hphob_Eisenberg ---Normalized consensus hydrophobicity scale.
                (Eisenberg D., Schwarz E., Komarony M., Wall R.)
                Hphob_Fauchere  ---Hydrophobicity scale (pi-r).
                (Fauchere J.-L., Pliska V.E.)
                Hphob_Guy   ---Hydrophobicity scale based on free energy of transfer
                (kcal/mole).    (Guy H.R.)
                Hphob_Janin ---Free energy of transfer from inside to outside of a globular
                protein.    (Janin J.)
                Hphob_Leo   ---Amino acid scale: Hydrophobicity (delta G1/2 cal)
                ( Abraham D.J., Leo A.J.)
                Hphob_Manavalan ---Average surrounding hydrophobicity.
                (Manavalan P., Ponnuswamy P.K.)
                Hphob_Miyazawa  ---Hydrophobicity scale (contact energy derived from 3D data).
                (Miyazawa S., Jernigen R.L.)
                Hphob_mobility  ---Mobilities of amino acids on chromatography paper (RF).
                (Aboderin A.A.)
                Hphob_Parker    ---Hydrophilicity scale derived from HPLC peptide retention
                times.  (Parker J.M.R., Guo D., Hodges R.S.)
                Hphob_pH3.4 ---Hydrophobicity indices at ph 3.4 determined by HPLC.
                (Cowan R., Whittaker R.G.)
                Hphob_pH7.5 ---Hydrophobicity indices at ph 7.5 determined by HPLC.
                (Cowan R., Whittaker R.G.)
                Hphob_Rose  ---Mean fractional area loss (f) [average area buried/standard
                                                              state area].    (Rose G.D., Geselowitz A.R.,
                                                                               Lesser G.J., Lee R.H., Zehfus M.H.)
                Hphob_Roseman   ---Hydrophobicity scale (pi-r).     (Roseman M.A.)
                Hphob_Sweet ---Optimized matching hydrophobicity (OMH).
                (Sweet R.M., Eisenberg D.)
                Hphob_Welling   ---Antigenicity value X 10.     (Welling G.W., Weijer W.J.,
                                                                 Van der Zee R., Welling-Wester S.)
                Hphob_Wilson    ---Hydrophobic constants derived from HPLC peptide retention
                times.
                (Wilson K.J., Honegger A., Stotzel R.P., Hughes G.J.)
                Hphob_Wolfenden ---Hydration potential (kcal/mole) at 25oC.     (Wolfenden R.V.,
                                                                                 Andersson L., Cullis P.M., Southgate C.C.F.)
                Hphob_Woods ---Hydrophilicity.  (Hopp T.P., Woods K.R.)
                HPLC2.1 ---Retention coefficient in HPLC, pH 2.1.   (Meek J.L.)
                HPLC7.4 ---Retention coefficient in HPLC, pH 7.4.   (Meek J.L.)
                HPLCHFBA    ---Retention coefficient in HFBA.
                (Browne C.A., Bennett H.P.J., Solomon S.)
                HPLCTFA ---Retention coefficient in TFA.
                (Browne C.A., Bennett H.P.J., Solomon S.)
                MolecularWeight ---Molecular weight of each amino acid.
                NumberCodons    ---Number of codon(s) coding for each amino acid in universal
                genetic code.
                ParallelBetaStrand  ---Amino acid scale: Conformational preference for
                parallel beta strand.   ( Lifson S., Sander C.)
                Polarity_Grantham   ---Polarity (p).    (Grantham R.)
                Polarity_Zimmerman  ---Polarity.    (Zimmerman J.M., Eliezer N., Simha R.)
                RatioSide   ---Atomic weight ratio of hetero elements in end group to C in
                side chain.     (Grantham R.)
                RecognitionFactors  ---Recognition factors.     (Fraga S.)
                Refractivity    ---Refractivity.    (Jones. D.D.)
                RelativeMutability  ---Relative mutability of amino acids (Ala=100).
                (Dayhoff M.O., Schwartz R.M., Orcutt B.C.)
                TotalBetaStrand ---Conformational preference for total beta strand
                (antiparallel+parallel).    (Lifson S., Sander C.)
                Hphob_Privalov_dCp  ---deltaCp hydration, J/(K*mol*A^2),
                (Privalov, P. L. & Khechinashvili, N. N.)
                Hphob_Privalov_dH   ---deltaH hydration, J/(mol*A^2), 25 oC
                (Privalov, P. L. & Khechinashvili, N. N.)
                Hphob_Privalov_dS   ---deltaS hydration, J/(K*mol*A^2), 25 oC
                (Privalov, P. L. & Khechinashvili, N. N.)
                Hphob_Privalov_dG   ---deltaG hydration, J/(mol*A^2), 25 oC
                (Privalov, P. L. & Khechinashvili, N. N.)
            }
            return
        }
        custom {
            # Custom Amino acid scale   Insert any values
            set wholeScale {
                {Ala    1}
                {Arg    2}
                {Asn    1}
                {Asp    2}
                {Cys    1}
                {Gln    2}
                {Glu    1}
                {Gly    2}
                {His    1}
                {Ile    2}
                {Leu    1}
                {Lys    2}
                {Met    1}
                {Phe    2}
                {Pro    1}
                {Ser    2}
                {Thr    1}
                {Trp    2}
                {Tyr    1}
                {Val    2}
            }
        }


        aa_composition {
            # Amino acid scale  Overall amino acid composition (%).
            # Author(s) McCaldon P., Argos P.
            # Reference Proteins    Structure, Function and Genetics 4  99-122(1988).
            # Amino acid scale values
            set wholeScale {
                {Ala    8.300}
                {Arg    5.700}
                {Asn    4.400}
                {Asp    5.300}
                {Cys    1.700}
                {Gln    4.000}
                {Glu    6.200}
                {Gly    7.200}
                {His    2.200}
                {Ile    5.200}
                {Leu    9.000}
                {Lys    5.700}
                {Met    2.400}
                {Phe    3.900}
                {Pro    5.100}
                {Ser    6.900}
                {Thr    5.800}
                {Trp    1.300}
                {Tyr    3.200}
                {Val    6.600}
            }
        }

        aa_swissprot {
            # Amino acid scale  Amino acid composition (%) in the Swiss-Prot Protein Sequence data bank.
            # Author(s) Bairoch A.
            # Reference Release notes for Swiss-Prot release 41 - February 2003.
            # Amino acid scale values
            set wholeScale {
                {Ala    7.720}
                {Arg    5.240}
                {Asn    4.280}
                {Asp    5.270}
                {Cys    1.600}
                {Gln    3.920}
                {Glu    6.540}
                {Gly    6.900}
                {His    2.260}
                {Ile    5.880}
                {Leu    9.560}
                {Lys    5.960}
                {Met    2.360}
                {Phe    4.060}
                {Pro    4.880}
                {Ser    6.980}
                {Thr    5.580}
                {Trp    1.180}
                {Tyr    3.130}
                {Val    6.660}
            }
        }

        accessibleresidues {
            # Amino acid scale  Molar fraction (%) of 3220 accessible residues.
            # Author(s) Janin J.
            # Reference Nature 277  491-492(1979).
            # Amino acid scale values
            set wholeScale {
                {Ala    6.600}
                {Arg    4.500}
                {Asn    6.700}
                {Asp    7.700}
                {Cys    0.900}
                {Gln    5.200}
                {Glu    5.700}
                {Gly    6.700}
                {His    2.500}
                {Ile    2.800}
                {Leu    4.800}
                {Lys    10.300}
                {Met    1.000}
                {Phe    2.400}
                {Pro    4.800}
                {Ser    9.400}
                {Thr    7.000}
                {Trp    1.400}
                {Tyr    5.100}
                {Val    4.500}
            }
        }

        alphahelix_fasman {
            # Amino acid scale: Conformational parameter for alpha helix (computed from 29 proteins).
            # Author(s): Chou P.Y., Fasman G.D.
            # Reference: Adv. Enzym. 47:45-148(1978).
            # Amino acid scale values:
            set wholeScale {
                {Ala    1.420}
                {Arg    0.980}
                {Asn    0.670}
                {Asp    1.010}
                {Cys    0.700}
                {Gln    1.110}
                {Glu    1.510}
                {Gly    0.570}
                {His    1.000}
                {Ile    1.080}
                {Leu    1.210}
                {Lys    1.160}
                {Met    1.450}
                {Phe    1.130}
                {Pro    0.570}
                {Ser    0.770}
                {Thr    0.830}
                {Trp    1.080}
                {Tyr    0.690}
                {Val    1.060}
            }
        }

        alphahelix_levitt {
            # Amino acid scale  Normalized frequency for alpha helix.
            # Author(s) Levitt M.
            # Reference Biochemistry 17 4277-4285(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.290}
                {Arg    0.960}
                {Asn    0.900}
                {Asp    1.040}
                {Cys    1.110}
                {Gln    1.270}
                {Glu    1.440}
                {Gly    0.560}
                {His    1.220}
                {Ile    0.970}
                {Leu    1.300}
                {Lys    1.230}
                {Met    1.470}
                {Phe    1.070}
                {Pro    0.520}
                {Ser    0.820}
                {Thr    0.820}
                {Trp    0.990}
                {Tyr    0.720}
                {Val    0.910}
            }
        }

        alphahelix_roux {
            # Amino acid scale  Conformational parameter for alpha helix.
            # Author(s) Deleage G., Roux B.
            # Reference Protein Engineering 1   289-294(1987).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.489}
                {Arg    1.224}
                {Asn    0.772}
                {Asp    0.924}
                {Cys    0.966}
                {Gln    1.164}
                {Glu    1.504}
                {Gly    0.510}
                {His    1.003}
                {Ile    1.003}
                {Leu    1.236}
                {Lys    1.172}
                {Met    1.363}
                {Phe    1.195}
                {Pro    0.492}
                {Ser    0.739}
                {Thr    0.785}
                {Trp    1.090}
                {Tyr    0.787}
                {Val    0.990}
            }
        }

        antiparallelbetastrand {
            # Amino acid scale  Conformational preference for antiparallel beta strand.
            # Author(s) Lifson S., Sander C.
            # Reference Nature 282  109-111(1979).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.900}
                {Arg    1.020}
                {Asn    0.620}
                {Asp    0.470}
                {Cys    1.240}
                {Gln    1.180}
                {Glu    0.620}
                {Gly    0.560}
                {His    1.120}
                {Ile    1.540}
                {Leu    1.260}
                {Lys    0.740}
                {Met    1.090}
                {Phe    1.230}
                {Pro    0.420}
                {Ser    0.870}
                {Thr    1.300}
                {Trp    1.750}
                {Tyr    1.680}
                {Val    1.530}
            }
        }

        averageburied {
            # Amino acid scale  Average area buried on transfer from standard state to folded protein.
            # Author(s) Rose G.D., Geselowitz A.R., Lesser G.J., Lee R.H., Zehfus M.H.
            # Reference Science 229 834-838(1985).
            # Amino acid scale values
            set wholeScale {
                {Ala    86.600}
                {Arg    162.200}
                {Asn    103.300}
                {Asp    97.800}
                {Cys    132.300}
                {Gln    119.200}
                {Glu    113.900}
                {Gly    62.900}
                {His    155.800}
                {Ile    158.000}
                {Leu    164.100}
                {Lys    115.500}
                {Met    172.900}
                {Phe    194.100}
                {Pro    92.900}
                {Ser    85.600}
                {Thr    106.500}
                {Trp    224.600}
                {Tyr    177.700}
                {Val    141.000}
            }
        }

        averageflexibility {
            # Amino acid scale  Average flexibility index.
            # Author(s) Bhaskaran R., Ponnuswamy P.K.
            # Reference Int. J. Pept. Protein. Res. 32  242-255(1988).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.360}
                {Arg    0.530}
                {Asn    0.460}
                {Asp    0.510}
                {Cys    0.350}
                {Gln    0.490}
                {Glu    0.500}
                {Gly    0.540}
                {His    0.320}
                {Ile    0.460}
                {Leu    0.370}
                {Lys    0.470}
                {Met    0.300}
                {Phe    0.310}
                {Pro    0.510}
                {Ser    0.510}
                {Thr    0.440}
                {Trp    0.310}
                {Tyr    0.420}
                {Val    0.390}
            }
        }

        betasheet_fasman {
            # Amino acid scale  Conformational parameter for beta-sheet (computed from 29 proteins).
            # Author(s) Chou P.Y., Fasman G.D.
            # Reference Adv. Enzym. 47  45-148(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.830}
                {Arg    0.930}
                {Asn    0.890}
                {Asp    0.540}
                {Cys    1.190}
                {Gln    1.100}
                {Glu    0.370}
                {Gly    0.750}
                {His    0.870}
                {Ile    1.600}
                {Leu    1.300}
                {Lys    0.740}
                {Met    1.050}
                {Phe    1.380}
                {Pro    0.550}
                {Ser    0.750}
                {Thr    1.190}
                {Trp    1.370}
                {Tyr    1.470}
                {Val    1.700}
            }
        }

        betasheet_levitt {
            # Amino acid scale  Normalized frequency for beta-sheet.
            # Author(s) Levitt M.
            # Reference Biochemistry 17 4277-4285(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.900}
                {Arg    0.990}
                {Asn    0.760}
                {Asp    0.720}
                {Cys    0.740}
                {Gln    0.800}
                {Glu    0.750}
                {Gly    0.920}
                {His    1.080}
                {Ile    1.450}
                {Leu    1.020}
                {Lys    0.770}
                {Met    0.970}
                {Phe    1.320}
                {Pro    0.640}
                {Ser    0.950}
                {Thr    1.210}
                {Trp    1.140}
                {Tyr    1.250}
                {Val    1.490}
            }
        }

        betasheet_roux {
            # Amino acid scale  Conformational parameter for beta-sheet.
            # Author(s) Deleage G., Roux B.
            # Reference Protein Engineering 1   289-294(1987).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.709}
                {Arg    0.920}
                {Asn    0.604}
                {Asp    0.541}
                {Cys    1.191}
                {Gln    0.840}
                {Glu    0.567}
                {Gly    0.657}
                {His    0.863}
                {Ile    1.799}
                {Leu    1.261}
                {Lys    0.721}
                {Met    1.210}
                {Phe    1.393}
                {Pro    0.354}
                {Ser    0.928}
                {Thr    1.221}
                {Trp    1.306}
                {Tyr    1.266}
                {Val    1.965}
            }
        }

        betaturn_fasman {
            # Amino acid scale  Conformational parameter for beta-turn (computed from 29 proteins).
            # Author(s) Chou P.Y., Fasman G.D.
            # Reference Adv. Enzym. 47  45-148(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.660}
                {Arg    0.950}
                {Asn    1.560}
                {Asp    1.460}
                {Cys    1.190}
                {Gln    0.980}
                {Glu    0.740}
                {Gly    1.560}
                {His    0.950}
                {Ile    0.470}
                {Leu    0.590}
                {Lys    1.010}
                {Met    0.600}
                {Phe    0.600}
                {Pro    1.520}
                {Ser    1.430}
                {Thr    0.960}
                {Trp    0.960}
                {Tyr    1.140}
                {Val    0.500}
            }
        }

        betaturn_levitt {
            # Amino acid scale  Normalized frequency for beta-turn.
            # Author(s) Levitt M.
            # Reference Biochemistry 17 4277-4285(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.770}
                {Arg    0.880}
                {Asn    1.280}
                {Asp    1.410}
                {Cys    0.810}
                {Gln    0.980}
                {Glu    0.990}
                {Gly    1.640}
                {His    0.680}
                {Ile    0.510}
                {Leu    0.580}
                {Lys    0.960}
                {Met    0.410}
                {Phe    0.590}
                {Pro    1.910}
                {Ser    1.320}
                {Thr    1.040}
                {Trp    0.760}
                {Tyr    1.050}
                {Val    0.470}
            }
        }

        betaturn_roux {
            # Amino acid scale  Conformational parameter for beta-turn.
            # Author(s) Deleage G., Roux B.
            # Reference Protein Engineering 1   289-294(1987).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.788}
                {Arg    0.912}
                {Asn    1.572}
                {Asp    1.197}
                {Cys    0.965}
                {Gln    0.997}
                {Glu    1.149}
                {Gly    1.860}
                {His    0.970}
                {Ile    0.240}
                {Leu    0.670}
                {Lys    1.302}
                {Met    0.436}
                {Phe    0.624}
                {Pro    1.415}
                {Ser    1.316}
                {Thr    0.739}
                {Trp    0.546}
                {Tyr    0.795}
                {Val    0.387}
            }
        }

        bulkiness {
            # Amino acid scale  Bulkiness.
            # Author(s) Zimmerman J.M., Eliezer N., Simha R.
            # Reference J. Theor. Biol. 21  170-201(1968).
            # Amino acid scale values
            set wholeScale {
                {Ala    11.500}
                {Arg    14.280}
                {Asn    12.820}
                {Asp    11.680}
                {Cys    13.460}
                {Gln    14.450}
                {Glu    13.570}
                {Gly    3.400}
                {His    13.690}
                {Ile    21.400}
                {Leu    21.400}
                {Lys    15.710}
                {Met    16.250}
                {Phe    19.800}
                {Pro    17.430}
                {Ser    9.470}
                {Thr    15.770}
                {Trp    21.670}
                {Tyr    18.030}
                {Val    21.570}
            }
        }

        buriedresidues {
            # Amino acid scale  Molar fraction (%) of 2001 buried residues.
            # Author(s) Janin J.
            # Reference Nature 277  491-492(1979).
            # Amino acid scale values
            set wholeScale {
                {Ala    11.200}
                {Arg    0.500}
                {Asn    2.900}
                {Asp    2.900}
                {Cys    4.100}
                {Gln    1.600}
                {Glu    1.800}
                {Gly    11.800}
                {His    2.000}
                {Ile    8.600}
                {Leu    11.700}
                {Lys    0.500}
                {Met    1.900}
                {Phe    5.100}
                {Pro    2.700}
                {Ser    8.000}
                {Thr    4.900}
                {Trp    2.200}
                {Tyr    2.600}
                {Val    12.900}
            }
        }

        coil_roux {
            # Amino acid scale  Conformational parameter for coil.
            # Author(s) Deleage G., Roux B.
            # Reference Protein Engineering 1   289-294(1987).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.824}
                {Arg    0.893}
                {Asn    1.167}
                {Asp    1.197}
                {Cys    0.953}
                X
                {Gln    0.947}
                {Glu    0.761}
                {Gly    1.251}
                {His    1.068}
                {Ile    0.886}
                {Leu    0.810}
                {Lys    0.897}
                {Met    0.810}
                {Phe    0.797}
                {Pro    1.540}
                {Ser    1.130}
                {Thr    1.148}
                {Trp    0.941}
                {Tyr    1.109}
                {Val    0.772}
            }
        }

        hphob_argos {
            # Amino acid scale  Membrane buried helix parameter.
            # Author(s) Rao M.J.K., Argos P.
            # Reference Biochim. Biophys. Acta 869  197-214(1986).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.360}
                {Arg    0.150}
                {Asn    0.330}
                {Asp    0.110}
                {Cys    1.270}
                {Gln    0.330}
                {Glu    0.250}
                {Gly    1.090}
                {His    0.680}
                {Ile    1.440}
                {Leu    1.470}
                {Lys    0.090}
                {Met    1.420}
                {Phe    1.570}
                {Pro    0.540}
                {Ser    0.970}
                {Thr    1.080}
                {Trp    1.000}
                {Tyr    0.830}
                {Val    1.370}
            }
        }

        hphob_black {
            # Amino acid scale: Hydrophobicity of physiological L-alpha amino acids
            # Author(s): Black S.D., Mould D.R.
            # Reference Anal. Biochem. 193  72-82(1991). .
            # Amino acid scale values
            set wholeScale {
                {Ala    0.616}
                {Arg    0.000}
                {Asn    0.236}
                {Asp    0.028}
                {Cys    0.680}
                {Gln    0.251}
                {Glu    0.043}
                {Gly    0.501}
                {His    0.165}
                {Ile    0.943}
                {Leu    0.943}
                {Lys    0.283}
                {Met    0.738}
                {Phe    1.000}
                {Pro    0.711}
                {Ser    0.359}
                {Thr    0.450}
                {Trp    0.878}
                {Tyr    0.880}
                {Val    0.825}
            }
        }

        hphob_breese {
            # Amino acid scale  Hydrophobicity (free energy of transfer to surface in kcal/mole).
            # Author(s) Bull H.B., Breese K.
            # Reference Arch. Biochem. Biophys. 161 665-670(1974).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.610}
                {Arg    0.690}
                {Asn    0.890}
                {Asp    0.610}
                {Cys    0.360}
                {Gln    0.970}
                {Glu    0.510}
                {Gly    0.810}
                {His    0.690}
                {Ile    -1.450}
                {Leu    -1.650}
                {Lys    0.460}
                {Met    -0.660}
                {Phe    -1.520}
                {Pro    -0.170}
                {Ser    0.420}
                {Thr    0.290}
                {Trp    -1.200}
                {Tyr    -1.430}
                {Val    -0.750}
            }
        }

        hphob_chothia {
            # Amino acid scale  Proportion of residues 95% buried (in 12 proteins).
            # Author(s) Chothia C.
            # Reference J. Mol. Biol. 105   1-14(1976).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.380}
                {Arg    0.010}
                {Asn    0.120}
                {Asp    0.150}
                {Cys    0.500}
                {Gln    0.070}
                {Glu    0.180}
                {Gly    0.360}
                {His    0.170}
                {Ile    0.600}
                {Leu    0.450}
                {Lys    0.030}
                {Met    0.400}
                {Phe    0.500}
                {Pro    0.180}
                {Ser    0.220}
                {Thr    0.230}
                {Trp    0.270}
                {Tyr    0.150}
                {Val    0.540}
            }
        }

        hphob_doolittle {
            # Amino acid scale  Hydropathicity.
            # Author(s) Kyte J., Doolittle R.F.
            # Reference J. Mol. Biol. 157   105-132(1982).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.800}
                {Arg    -4.500}
                {Asn    -3.500}
                {Asp    -3.500}
                {Cys    2.500}
                {Gln    -3.500}
                {Glu    -3.500}
                {Gly    -0.400}
                {His    -3.200}
                {Ile    4.500}
                {Leu    3.800}
                {Lys    -3.900}
                {Met    1.900}
                {Phe    2.800}
                {Pro    -1.600}
                {Ser    -0.800}
                {Thr    -0.700}
                {Trp    -0.900}
                {Tyr    -1.300}
                {Val    4.200}
            }
        }

        hphob_eisenberg {
            # Amino acid scale  Normalized consensus hydrophobicity scale.
            # Author(s) Eisenberg D., Schwarz E., Komarony M., Wall R.
            # Reference J. Mol. Biol. 179   125-142(1984).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.620}
                {Arg    -2.530}
                {Asn    -0.780}
                {Asp    -0.900}
                {Cys    0.290}
                {Gln    -0.850}
                {Glu    -0.740}
                {Gly    0.480}
                {His    -0.400}
                {Ile    1.380}
                {Leu    1.060}
                {Lys    -1.500}
                {Met    0.640}
                {Phe    1.190}
                {Pro    0.120}
                {Ser    -0.180}
                {Thr    -0.050}
                {Trp    0.810}
                {Tyr    0.260}
                {Val    1.080}
            }
        }

        hphob_fauchere {
            # Amino acid scale  Hydrophobicity scale (pi-r).
            # Author(s) Fauchere J.-L., Pliska V.E.
            # Reference Eur. J. Med. Chem. 18   369-375(1983).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.310}
                {Arg    -1.010}
                {Asn    -0.600}
                {Asp    -0.770}
                {Cys    1.540}
                {Gln    -0.220}
                {Glu    -0.640}
                {Gly    0.000}
                {His    0.130}
                {Ile    1.800}
                {Leu    1.700}
                {Lys    -0.990}
                {Met    1.230}
                {Phe    1.790}
                {Pro    0.720}
                {Ser    -0.040}
                {Thr    0.260}
                {Trp    2.250}
                {Tyr    0.960}
                {Val    1.220}
            }
        }

        hphob_guy {
            # Amino acid scale  Hydrophobicity scale based on free energy of transfer (kcal/mole).
            # Author(s) Guy H.R.
            # Reference Biophys J. 47   61-70(1985).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.100}
                {Arg    1.910}
                {Asn    0.480}
                {Asp    0.780}
                {Cys    -1.420}
                {Gln    0.950}
                {Glu    0.830}
                {Gly    0.330}
                {His    -0.500}
                {Ile    -1.130}
                {Leu    -1.180}
                {Lys    1.400}
                {Met    -1.590}
                {Phe    -2.120}
                {Pro    0.730}
                {Ser    0.520}
                {Thr    0.070}
                {Trp    -0.510}
                {Tyr    -0.210}
                {Val    -1.270}
            }
        }

        hphob_janin {
            # Amino acid scale  Free energy of transfer from inside to outside of a globular protein.
            # Author(s) Janin J.
            # Reference Nature 277  491-492(1979).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.300}
                {Arg    -1.400}
                {Asn    -0.500}
                {Asp    -0.600}
                {Cys    0.900}
                {Gln    -0.700}
                {Glu    -0.700}
                {Gly    0.300}
                {His    -0.100}
                {Ile    0.700}
                {Leu    0.500}
                {Lys    -1.800}
                {Met    0.400}
                {Phe    0.500}
                {Pro    -0.300}
                {Ser    -0.100}
                {Thr    -0.200}
                {Trp    0.300}
                {Tyr    -0.400}
                {Val    0.600}
            }
        }

        hphob_leo {
            # Amino acid scale: Hydrophobicity (delta G1/2 cal)
            # Author(s): Abraham D.J., Leo A.J.
            # Reference Proteins    Structure, Function and Genetics 2  130-152(1987).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.440}
                {Arg    -2.420}
                {Asn    -1.320}
                {Asp    -0.310}
                {Cys    0.580}
                {Gln    -0.710}
                {Glu    -0.340}
                {Gly    0.000}
                {His    -0.010}
                {Ile    2.460}
                {Leu    2.460}
                {Lys    -2.450}
                {Met    1.100}
                {Phe    2.540}
                {Pro    1.290}
                {Ser    -0.840}
                {Thr    -0.410}
                {Trp    2.560}
                {Tyr    1.630}
                {Val    1.730}
            }
        }

        hphob_manavalan {
            # Amino acid scale  Average surrounding hydrophobicity.
            # Author(s) Manavalan P., Ponnuswamy P.K.
            # Reference Nature 275  673-674(1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    12.970}
                {Arg    11.720}
                {Asn    11.420}
                {Asp    10.850}
                {Cys    14.630}
                {Gln    11.760}
                {Glu    11.890}
                {Gly    12.430}
                {His    12.160}
                {Ile    15.670}
                {Leu    14.900}
                {Lys    11.360}
                {Met    14.390}
                {Phe    14.000}
                {Pro    11.370}
                {Ser    11.230}
                {Thr    11.690}
                {Trp    13.930}
                {Tyr    13.420}
                {Val    15.710}
            }
        }

        hphob_miyazawa {
            # Amino acid scale  Hydrophobicity scale (contact energy derived from 3D data).
            # Author(s) Miyazawa S., Jernigen R.L.
            # Reference Macromolecules 18   534-552(1985).
            # Amino acid scale values
            set wholeScale {
                {Ala    5.330}
                {Arg    4.180}
                {Asn    3.710}
                {Asp    3.590}
                {Cys    7.930}
                {Gln    3.870}
                {Glu    3.650}
                {Gly    4.480}
                {His    5.100}
                {Ile    8.830}
                {Leu    8.470}
                {Lys    2.950}
                {Met    8.950}
                {Phe    9.030}
                {Pro    3.870}
                {Ser    4.090}
                {Thr    4.490}
                {Trp    7.660}
                {Tyr    5.890}
                {Val    7.630}
            }
        }

        hphob_mobility {
            # Amino acid scale  Mobilities of amino acids on chromatography paper (RF).
            # Author(s) Aboderin A.A.
            # Reference Int. J. Biochem. 2  537-544(1971).
            # Amino acid scale values
            set wholeScale {
                {Ala    5.100}
                {Arg    2.000}
                {Asn    0.600}
                {Asp    0.700}
                {Cys    0.000}
                {Gln    1.400}
                {Glu    1.800}
                {Gly    4.100}
                {His    1.600}
                {Ile    9.300}
                {Leu    10.000}
                {Lys    1.300}
                {Met    8.700}
                {Phe    9.600}
                {Pro    4.900}
                {Ser    3.100}
                {Thr    3.500}
                {Trp    9.200}
                {Tyr    8.000}
                {Val    8.500}
            }
        }

        hphob_parker {
            # Amino acid scale  Hydrophilicity scale derived from HPLC peptide retention times.
            # Author(s) Parker J.M.R., Guo D., Hodges R.S.
            # Reference Biochemistry 25 5425-5431(1986).
            # Amino acid scale values
            set wholeScale {
                {Ala    2.100}
                {Arg    4.200}
                {Asn    7.000}
                {Asp    10.000}
                {Cys    1.400}
                {Gln    6.000}
                {Glu    7.800}
                {Gly    5.700}
                {His    2.100}
                {Ile    -8.000}
                {Leu    -9.200}
                {Lys    5.700}
                {Met    -4.200}
                {Phe    -9.200}
                {Pro    2.100}
                {Ser    6.500}
                {Thr    5.200}
                {Trp    -10.000}
                {Tyr    -1.900}
                {Val    -3.700}
            }
        }

        hphob_ph3.4 {
            # Amino acid scale  Hydrophobicity indices at ph 3.4 determined by HPLC.
            # Author(s) Cowan R., Whittaker R.G.
            # Reference Peptide Research 3  75-80(1990).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.420}
                {Arg    -1.560}
                {Asn    -1.030}
                {Asp    -0.510}
                {Cys    0.840}
                {Gln    -0.960}
                {Glu    -0.370}
                {Gly    0.000}
                {His    -2.280}
                {Ile    1.810}
                {Leu    1.800}
                {Lys    -2.030}
                {Met    1.180}
                {Phe    1.740}
                {Pro    0.860}
                {Ser    -0.640}
                {Thr    -0.260}
                {Trp    1.460}
                {Tyr    0.510}
                {Val    1.340}
            }
        }

        hphob_ph7.5 {
            # Amino acid scale  Hydrophobicity indices at ph 7.5 determined by HPLC.
            # Author(s) Cowan R., Whittaker R.G.
            # Reference Peptide Research 3  75-80(1990).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.350}
                {Arg    -1.500}
                {Asn    -0.990}
                {Asp    -2.150}
                {Cys    0.760}
                {Gln    -0.930}
                {Glu    -1.950}
                {Gly    0.000}
                {His    -0.650}
                {Ile    1.830}
                {Leu    1.800}
                {Lys    -1.540}
                {Met    1.100}
                {Phe    1.690}
                {Pro    0.840}
                {Ser    -0.630}
                {Thr    -0.270}
                {Trp    1.350}
                {Tyr    0.390}
                {Val    1.320}
            }
        }

        hphob_rose {
            # Amino acid scale  Mean fractional area loss (f) [average area buried/standard state area].
            # Author(s) Rose G.D., Geselowitz A.R., Lesser G.J., Lee R.H., Zehfus M.H.
            # Reference Science 229 834-838(1985).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.740}
                {Arg    0.640}
                {Asn    0.630}
                {Asp    0.620}
                {Cys    0.910}
                {Gln    0.620}
                {Glu    0.620}
                {Gly    0.720}
                {His    0.780}
                {Ile    0.880}
                {Leu    0.850}
                {Lys    0.520}
                {Met    0.850}
                {Phe    0.880}
                {Pro    0.640}
                {Ser    0.660}
                {Thr    0.700}
                {Trp    0.850}
                {Tyr    0.760}
                {Val    0.860}
            }
        }

        hphob_roseman {
            # Amino acid scale  Hydrophobicity scale (pi-r).
            # Author(s) Roseman M.A.
            # Reference J. Mol. Biol. 200   513-522(1988).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.390}
                {Arg    -3.950}
                {Asn    -1.910}
                {Asp    -3.810}
                {Cys    0.250}
                {Gln    -1.300}
                {Glu    -2.910}
                {Gly    0.000}
                {His    -0.640}
                {Ile    1.820}
                {Leu    1.820}
                {Lys    -2.770}
                {Met    0.960}
                {Phe    2.270}
                {Pro    0.990}
                {Ser    -1.240}
                {Thr    -1.000}
                {Trp    2.130}
                {Tyr    1.470}
                {Val    1.300}
            }
        }

        hphob_sweet {
            # Amino acid scale  Optimized matching hydrophobicity (OMH).
            # Author(s) Sweet R.M., Eisenberg D.
            # Reference J. Mol. Biol. 171   479-488(1983).
            # Amino acid scale values
            set wholeScale {
                {Ala    -0.400}
                {Arg    -0.590}
                {Asn    -0.920}
                {Asp    -1.310}
                {Cys    0.170}
                {Gln    -0.910}
                {Glu    -1.220}
                {Gly    -0.670}
                {His    -0.640}
                {Ile    1.250}
                {Leu    1.220}
                {Lys    -0.670}
                {Met    1.020}
                {Phe    1.920}
                {Pro    -0.490}
                {Ser    -0.550}
                {Thr    -0.280}
                {Trp    0.500}
                {Tyr    1.670}
                {Val    0.910}
            }
        }

        hphob_welling {
            # Amino acid scale  Antigenicity value X 10.
            # Author(s) Welling G.W., Weijer W.J., Van der Zee R., Welling-Wester S.
            # Reference FEBS Lett. 188  215-218(1985).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.150}
                {Arg    0.580}
                {Asn    -0.770}
                {Asp    0.650}
                {Cys    -1.200}
                {Gln    -0.110}
                {Glu    -0.710}
                {Gly    -1.840}
                {His    3.120}
                {Ile    -2.920}
                {Leu    0.750}
                {Lys    2.060}
                {Met    -3.850}
                {Phe    -1.410}
                {Pro    -0.530}
                {Ser    -0.260}
                {Thr    -0.450}
                {Trp    -1.140}
                {Tyr    0.130}
                {Val    -0.130}
            }
        }

        hphob_wilson {
            # Amino acid scale  Hydrophobic constants derived from HPLC peptide retention times.
            # Author(s) Wilson K.J., Honegger A., Stotzel R.P., Hughes G.J.
            # Reference Biochem. J. 199 31-41(1981).
            # Amino acid scale values
            set wholeScale {
                {Ala    -0.300}
                {Arg    -1.100}
                {Asn    -0.200}
                {Asp    -1.400}
                {Cys    6.300}
                {Gln    -0.200}
                {Glu    0.000}
                {Gly    1.200}
                {His    -1.300}
                {Ile    4.300}
                {Leu    6.600}
                {Lys    -3.600}
                {Met    2.500}
                {Phe    7.500}
                {Pro    2.200}
                {Ser    -0.600}
                {Thr    -2.200}
                {Trp    7.900}
                {Tyr    7.100}
                {Val    5.900}
            }
        }

        hphob_wolfenden {
            # Amino acid scale  Hydration potential (kcal/mole) at 25oC.
            # Author(s) Wolfenden R.V., Andersson L., Cullis P.M., Southgate C.C.F.
            # Reference Biochemistry 20 849-855(1981).
            # Amino acid scale values
            set wholeScale {
                {Ala    1.940}
                {Arg    -19.920}
                {Asn    -9.680}
                {Asp    -10.950}
                {Cys    -1.240}
                {Gln    -9.380}
                {Glu    -10.200}
                {Gly    2.390}
                {His    -10.270}
                {Ile    2.150}
                {Leu    2.280}
                {Lys    -9.520}
                {Met    -1.480}
                {Phe    -0.760}
                {Pro    0.000}
                {Ser    -5.060}
                {Thr    -4.880}
                {Trp    -5.880}
                {Tyr    -6.110}
                {Val    1.990}
            }
        }

        hphob_woods {
            # Amino acid scale  Hydrophilicity.
            # Author(s) Hopp T.P., Woods K.R.
            # Reference Proc. Natl. Acad. Sci. U.S.A. 78    3824-3828(1981).
            # Amino acid scale values
            set wholeScale {
                {Ala    -0.500}
                {Arg    3.000}
                {Asn    0.200}
                {Asp    3.000}
                {Cys    -1.000}
                {Gln    0.200}
                {Glu    3.000}
                {Gly    0.000}
                {His    -0.500}
                {Ile    -1.800}
                {Leu    -1.800}
                {Lys    3.000}
                {Met    -1.300}
                {Phe    -2.500}
                {Pro    0.000}
                {Ser    0.300}
                {Thr    -0.400}
                {Trp    -3.400}
                {Tyr    -2.300}
                {Val    -1.500}
            }
        }

        hplc2.1 {
            # Amino acid scale  Retention coefficient in HPLC, pH 2.1.
            # Author(s) Meek J.L.
            # Reference Proc. Natl. Acad. Sci. USA 77   1632-1636(1980).
            # Amino acid scale values
            set wholeScale {
                {Ala    -0.100}
                {Arg    -4.500}
                {Asn    -1.600}
                {Asp    -2.800}
                {Cys    -2.200}
                {Gln    -2.500}
                {Glu    -7.500}
                {Gly    -0.500}
                {His    0.800}
                {Ile    11.800}
                {Leu    10.000}
                {Lys    -3.200}
                {Met    7.100}
                {Phe    13.900}
                {Pro    8.000}
                {Ser    -3.700}
                {Thr    1.500}
                {Trp    18.100}
                {Tyr    8.200}
                {Val    3.300}
            }
        }

        hplc7.4 {
            # Amino acid scale  Retention coefficient in HPLC, pH 7.4.
            # Author(s) Meek J.L.
            # Reference Proc. Natl. Acad. Sci. USA 77   1632-1636(1980).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.500}
                {Arg    0.800}
                {Asn    0.800}
                {Asp    -8.200}
                {Cys    -6.800}
                {Gln    -4.800}
                {Glu    -16.900}
                {Gly    0.000}
                {His    -3.500}
                {Ile    13.900}
                {Leu    8.800}
                {Lys    0.100}
                {Met    4.800}
                {Phe    13.200}
                {Pro    6.100}
                {Ser    1.200}
                {Thr    2.700}
                {Trp    14.900}
                {Tyr    6.100}
                {Val    2.700}
            }
        }

        hplchfba {
            # Amino acid scale  Retention coefficient in HFBA.
            # Author(s) Browne C.A., Bennett H.P.J., Solomon S.
            # Reference Anal. Biochem. 124  201-208(1982).
            # Amino acid scale values
            set wholeScale {
                {Ala    3.900}
                {Arg    3.200}
                {Asn    -2.800}
                {Asp    -2.800}
                {Cys    -14.300}
                {Gln    1.800}
                {Glu    -7.500}
                {Gly    -2.300}
                {His    2.000}
                {Ile    11.000}
                {Leu    15.000}
                {Lys    -2.500}
                {Met    4.100}
                {Phe    14.700}
                {Pro    5.600}
                {Ser    -3.500}
                {Thr    1.100}
                {Trp    17.800}
                {Tyr    3.800}
                {Val    2.100}
            }
        }

        hplctfa {
            # Amino acid scale  Retention coefficient in TFA.
            # Author(s) Browne C.A., Bennett H.P.J., Solomon S.
            # Reference Anal. Biochem. 124  201-208(1982).
            # Amino acid scale values
            set wholeScale {
                {Ala    7.300}
                {Arg    -3.600}
                {Asn    -5.700}
                {Asp    -2.900}
                {Cys    -9.200}
                {Gln    -0.300}
                {Glu    -7.100}
                {Gly    -1.200}
                {His    -2.100}
                {Ile    6.600}
                {Leu    20.000}
                {Lys    -3.700}
                {Met    5.600}
                {Phe    19.200}
                {Pro    5.100}
                {Ser    -4.100}
                {Thr    0.800}
                {Trp    16.300}
                {Tyr    5.900}
                {Val    3.500}
            }
        }

        molecularweight {
            # Amino acid scale  Molecular weight of each amino acid.
            # Author(s) -
            # Reference Most textbooks.
            # Amino acid scale values
            set wholeScale {
                {Ala    89.000}
                {Arg    174.000}
                {Asn    132.000}
                {Asp    133.000}
                {Cys    121.000}
                {Gln    146.000}
                {Glu    147.000}
                {Gly    75.000}
                {His    155.000}
                {Ile    131.000}
                {Leu    131.000}
                {Lys    146.000}
                {Met    149.000}
                {Phe    165.000}
                {Pro    115.000}
                {Ser    105.000}
                {Thr    119.000}
                {Trp    204.000}
                {Tyr    181.000}
                {Val    117.000}
            }
        }

        numbercodons {
            # Amino acid scale  Number of codon(s) coding for each amino acid in universal genetic code.
            # Author(s) -
            # Reference Most textbooks.
            # Amino acid scale values
            set wholeScale {
                {Ala    4.000}
                {Arg    6.000}
                {Asn    2.000}
                {Asp    2.000}
                {Cys    2.000}
                {Gln    2.000}
                {Glu    2.000}
                {Gly    4.000}
                {His    2.000}
                {Ile    3.000}
                {Leu    6.000}
                {Lys    2.000}
                {Met    1.000}
                {Phe    2.000}
                {Pro    4.000}
                {Ser    6.000}
                {Thr    4.000}
                {Trp    1.000}
                {Tyr    2.000}
                {Val    4.000}
            }
        }

        parallelbetastrand {
            # Amino acid scale: Conformational preference for parallel beta strand.
            # Author(s): Lifson S., Sander C.
            # Reference: Nature 282:109-111(1979).
            # Amino acid scale values:
            set wholeScale {
                {Ala    1.000}
                {Arg    0.680}
                {Asn    0.540}
                {Asp    0.500}
                {Cys    0.910}
                {Gln    0.280}
                {Glu    0.590}
                {Gly    0.790}
                {His    0.380}
                {Ile    2.600}
                {Leu    1.420}
                {Lys    0.590}
                {Met    1.490}
                {Phe    1.300}
                {Pro    0.350}
                {Ser    0.700}
                {Thr    0.590}
                {Trp    0.890}
                {Tyr    1.080}
                {Val    2.630}
            }
        }

        polarity_grantham {
            # Amino acid scale  Polarity (p).
            # Author(s) Grantham R.
            # Reference Science 185 862-864(1974).
            # Amino acid scale values
            set wholeScale {
                {Ala    8.100}
                {Arg    10.500}
                {Asn    11.600}
                {Asp    13.000}
                {Cys    5.500}
                {Gln    10.500}
                {Glu    12.300}
                {Gly    9.000}
                {His    10.400}
                {Ile    5.200}
                {Leu    4.900}
                {Lys    11.300}
                {Met    5.700}
                {Phe    5.200}
                {Pro    8.000}
                {Ser    9.200}
                {Thr    8.600}
                {Trp    5.400}
                {Tyr    6.200}
                {Val    5.900}
            }
        }

        polarity_zimmerman {
            # Amino acid scale  Polarity.
            # Author(s) Zimmerman J.M., Eliezer N., Simha R.
            # Reference J. Theor. Biol. 21  170-201(1968).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.000}
                {Arg    52.000}
                {Asn    3.380}
                {Asp    49.700}
                {Cys    1.480}
                {Gln    3.530}
                {Glu    49.900}
                {Gly    0.000}
                {His    51.600}
                {Ile    0.130}
                {Leu    0.130}
                {Lys    49.500}
                {Met    1.430}
                {Phe    0.350}
                {Pro    1.580}
                {Ser    1.670}
                {Thr    1.660}
                {Trp    2.100}
                {Tyr    1.610}
                {Val    0.130}
            }
        }

        ratioside {
            # Amino acid scale  Atomic weight ratio of hetero elements in end group to C in side chain.
            # Author(s) Grantham R.
            # Reference Science 185 862-864(1974).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.000}
                {Arg    0.650}
                {Asn    1.330}
                {Asp    1.380}
                {Cys    2.750}
                {Gln    0.890}
                {Glu    0.920}
                {Gly    0.740}
                {His    0.580}
                {Ile    0.000}
                {Leu    0.000}
                {Lys    0.330}
                {Met    0.000}
                {Phe    0.000}
                {Pro    0.390}
                {Ser    1.420}
                {Thr    0.710}
                {Trp    0.130}
                {Tyr    0.200}
                {Val    0.000}
            }
        }

        recognitionfactors {
            # Amino acid scale  Recognition factors.
            # Author(s) Fraga S.
            # Reference Can. J. Chem. 60    2606-2610(1982).
            # Amino acid scale values
            set wholeScale {
                {Ala    78.000}
                {Arg    95.000}
                {Asn    94.000}
                {Asp    81.000}
                {Cys    89.000}
                {Gln    87.000}
                {Glu    78.000}
                {Gly    84.000}
                {His    84.000}
                {Ile    88.000}
                {Leu    85.000}
                {Lys    87.000}
                {Met    80.000}
                {Phe    81.000}
                {Pro    91.000}
                {Ser    107.000}
                {Thr    93.000}
                {Trp    104.000}
                {Tyr    84.000}
                {Val    89.000}
            }
        }

        refractivity {
            # Amino acid scale  Refractivity.
            # Author(s) Jones. D.D.
            # Reference J. Theor. Biol. 50  167-184(1975).
            # Amino acid scale values
            set wholeScale {
                {Ala    4.340}
                {Arg    26.660}
                {Asn    12.000}
                {Asp    13.280}
                {Cys    35.770}
                {Gln    17.260}
                {Glu    17.560}
                {Gly    0.000}
                {His    21.810}
                {Ile    18.780}
                {Leu    19.060}
                {Lys    21.290}
                {Met    21.640}
                {Phe    29.400}
                {Pro    10.930}
                {Ser    6.350}
                {Thr    11.010}
                {Trp    42.530}
                {Tyr    31.530}
                {Val    13.920}
            }
        }

        relativemutability {
            # Amino acid scale  Relative mutability of amino acids (Ala=100).
            # Author(s) Dayhoff M.O., Schwartz R.M., Orcutt B.C.
            # Reference In "Atlas of Protein Sequence and Structure", Vol.5, Suppl.3 (1978).
            # Amino acid scale values
            set wholeScale {
                {Ala    100.000}
                {Arg    65.000}
                {Asn    134.000}
                {Asp    106.000}
                {Cys    20.000}
                {Gln    93.000}
                {Glu    102.000}
                {Gly    49.000}
                {His    66.000}
                {Ile    96.000}
                {Leu    40.000}
                {Lys    56.000}
                {Met    94.000}
                {Phe    41.000}
                {Pro    56.000}
                {Ser    120.000}
                {Thr    97.000}
                {Trp    18.000}
                {Tyr    41.000}
                {Val    74.000}
            }
        }

        totalbetastrand {
            # Amino acid scale  Conformational preference for total beta strand (antiparallel+parallel).
            # Author(s) Lifson S., Sander C.
            # Reference Nature 282  109-111(1979).
            # Amino acid scale values
            set wholeScale {
                {Ala    0.920}
                {Arg    0.930}
                {Asn    0.600}
                {Asp    0.480}
                {Cys    1.160}
                {Gln    0.950}
                {Glu    0.610}
                {Gly    0.610}
                {His    0.930}
                {Ile    1.810}
                {Leu    1.300}
                {Lys    0.700}
                {Met    1.190}
                {Phe    1.250}
                {Pro    0.400}
                {Ser    0.820}
                {Thr    1.120}
                {Trp    1.540}
                {Tyr    1.530}
                {Val    1.810}
            }
        }

        hphob_privalov_dcp {
            # Amino acid scale  deltaCp hydration, J/(K*mol*A^2), 25 oC
            # Author(s) Privalov, P. L. & Khechinashvili, N. N.
            # Reference  J. Mol. Biol. (1974) 86, 665-684.
            # Amino acid scale values
            set wholeScale {
                {Ala    2.14}
                {Arg    -0.2}
                {Asn    -1.01}
                {Asp    -1.4}
                {Cys    2.01}
                {Gln    -0.22}
                {Glu    -0.55}
                {Gly    2.14}
                {His    -2.43}
                {Ile    2.14}
                {Leu    2.14}
                {Lys    -1.53}
                {Met    -3.83}
                {Phe    1.55}
                {Pro    1.55}
                {Ser    -1.4}
                {Thr    -1.29}
                {Trp    0.96}
                {Tyr    -1.48}
                {Val    2.14}
            }
        }

        hphob_privalov_dh {
            # Amino acid scale  deltaH hydration, J/(mol*A^2), 25 oC
            # Author(s) Privalov, P. L. & Khechinashvili, N. N.
            # Reference  J. Mol. Biol. (1974) 86, 665-684.
            # Amino acid scale values
            set wholeScale {
                {Ala    -122}
                {Arg    -827}
                {Asn    -894}
                {Asp    -715}
                {Cys    -271}
                {Gln    -703}
                {Glu    -562}
                {Gly    -122}
                {His    -1128}
                {Ile    -122}
                {Leu    -122}
                {Lys    -714}
                {Met    -473}
                {Phe    -148}
                {Pro    -148}
                {Ser    -1045}
                {Thr    -1287}
                {Trp    -1161}
                {Tyr    -854}
                {Val    -122}
            }
        }

        hphob_privalov_ds {
            # Amino acid scale  deltaS hydration, J/(K*mol*A^2), 25 oC
            # Author(s) Privalov, P. L. & Khechinashvili, N. N.
            # Reference  J. Mol. Biol. (1974) 86, 665-684.
            # Amino acid scale values
            set wholeScale {
                {Ala    -578}
                {Arg    -478}
                {Asn    -654}
                {Asp    -469}
                {Cys    -402}
                {Gln    -591}
                {Glu    -436}
                {Gly    -578}
                {His    -693}
                {Ile    -578}
                {Leu    -578}
                {Lys    -482}
                {Met    -412}
                {Phe    -319}
                {Pro    -319}
                {Ser    -983}
                {Thr    -1053}
                {Trp    -693}
                {Tyr    -415}
                {Val    -578}
            }
        }

        hphob_privalov_dg {
            # Amino acid scale  deltaG hydration, J/(mol*A^2), 25 oC
            # Author(s) Privalov, P. L. & Khechinashvili, N. N.
            # Reference  J. Mol. Biol. (1974) 86, 665-684.
            # Amino acid scale values
            set wholeScale {
                {Ala    50}
                {Arg    -685}
                {Asn    -699}
                {Asp    -575}
                {Cys    -151}
                {Gln    -527}
                {Glu    -432}
                {Gly    50}
                {His    -922}
                {Ile    50}
                {Leu    50}
                {Lys    -570}
                {Met    -350}
                {Phe    -53}
                {Pro    -53}
                {Ser    -752}
                {Thr    -972}
                {Trp    -954}
                {Tyr    -730}
                {Val    50}
            }
        }

        default {
            puts "Unrecognized scale   '$scale'"
        }

    }

    foreach aminoAcid $wholeScale {
        set a [atomselect top "resname [string toupper [lindex $aminoAcid 0]]"]
        $a set beta [lindex $aminoAcid 1]
        $a delete
    }
    #   #Apply preselected graphical representation
    #   mol representation VDW 1.000000 8.000000
    #   mol color Beta
    #   mol selection {protein}
    #   mol material Opaque
    #   mol addrep top
    display update
    colorscale_jet

    switch $opt {
        none {
        }

        scale {
            puts "Amino acid scale '$scale'"
            puts "Amino acid scale values:"
            foreach aminoAcid $wholeScale {
                puts $aminoAcid
            }
        }

        default {
            puts "Unrecognized option   '$opt'"
        }
    }
}
