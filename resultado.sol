Problem:    farmarcia
Rows:       6
Columns:    3 (3 integer, 0 binary)
Non-zeros:  12
Status:     INTEGER OPTIMAL
Objective:  Custo_Total = 12750 (MINimum)

   No.   Row name        Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 Custo_Total             12750                             
     2 Atende_Demanda[P1]
                                 150           150               
     3 Atende_Demanda[P2]
                                 100           100               
     4 Atende_Demanda[P3]
                                 150           150               
     5 Capacidade[Misturador]
                                 825                        1200 
     6 Capacidade[Reator]
                                 975                        1000 

   No. Column name       Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 x[P1]        *            150             0               
     2 x[P2]        *            100             0               
     3 x[P3]        *            150             0               

Integer feasibility conditions:

KKT.PE: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.PB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

End of output
