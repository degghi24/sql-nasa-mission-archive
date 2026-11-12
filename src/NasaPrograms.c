//Filippo De Guio(2113177) e Antonio Hai Xu(2111017)
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "dep/include/libpq-fe.h"


#define PG_HOST "localhost"
#define PG_USER "postgres"
#define PG_DB "Progetto_DB26"
#define PG_PASS "1234"
#define PG_PORT 5432




//Funzione per controllare i risultati
void checkResults(PGresult* res, PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        printf("Risultati inconsistenti: %s\n", PQerrorMessage(conn));
        PQclear(res);
        PQfinish(conn);
        exit(1);
    }
}


//Funzione per stampare i risultati delle query
void printResult(int rows, int cols, PGresult* res) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%-30s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }
}


int main(int argc, char** argv) {

    char conninfo[250];
    snprintf(conninfo,sizeof(conninfo), "user=%s password=%s dbname=%s host=%s port=%d",
        PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);


    PGconn* conn = PQconnectdb(conninfo);


    if (PQstatus(conn) != CONNECTION_OK)
    {
        printf("Errore di connessione: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }
    printf("Connessione avvenuta correttamente in %s", PG_DB);


    //Intro: scelta delle query
    int termina = 0;
    while (termina != 1) {
        printf("\nBenvenuto nel database dei programmi spaziali di Nasa!\nPuoi eseguire 5 query:\n");
        int numero_query = 0;
        printf("Query 1: mostrare i siti di lancio da cui sono decollate almeno 3 missioni.\nQuery 2: trovare numero di astronauti impiegati in missioni per ciascuna agenzia spaziale."
            "\nQuery 3: contare il numero di satelliti prodotti da ciascun produttore.\n");
        printf("Query 4: calcolare la durata totale delle missioni robotiche per ciascun robot.\nQuery 5: trovare il numero di esperimenti coinvolti in missioni per agenzia spaziale.\n");
        printf("Premi un numero da 1 a 5!\n");
        scanf_s("%d", &numero_query);

        PGresult* res;


        //query 1
        if (numero_query == 1) {
            const char* query1 = "SELECT S.CodiceSito, S.NomeSito , COUNT(M. CodMissione ) AS NumMissioni FROM SitoDiLancio S JOIN Missione M ON S. CodiceSito = M. SitoDiLancio GROUP BY S.CodiceSito , S. NomeSito HAVING COUNT(M. CodMissione) > 3";           
            res = PQprepare(conn, "query1", query1, 1, NULL);
            res = PQexec(conn, query1);
            checkResults(res, conn);

            //stampa risultato
            int tuple = PQntuples(res);
            int campi = PQnfields(res);
            printf("Il numero di missioni per ogni sito di lancio.\n");
            printf("\n");
            printf("%-30s%-30s%-30s\n",
            "Codice Sito",
            "Nome Sito",
            "Numero Missioni");
            printResult(tuple, campi, res);
            PQclear(res);
        }

        //query 2
        else if (numero_query == 2) {
            const char* query2 = "SELECT A. AgenziaSpaziale , COUNT( DISTINCT A. Callsign ) AS NumAstronauti FROM Astronauta A JOIN Personale P ON A. Callsign = P. Astronauta GROUP BY A. AgenziaSpaziale";            
            res = PQprepare(conn, "query2", query2, 1, NULL);
            int soglia = 0;

            res = PQexec(conn, query2);
            checkResults(res, conn);

            //stampa risultato
            int tuple = PQntuples(res);
            int campi = PQnfields(res);
            printf("Ecco il numero di astronauti impiegati in missioni per ciascuna agenzia spaziale.\n");
            printf("\n");
            printf("%-30s%-30s\n",
            "Agenzia Spaziale",
            "Numero Astronauti");
            printResult(tuple, campi, res);
            PQclear(res);
        }

        //query 3
        else if (numero_query == 3) {
            const char* query3 = "SELECT P.CodiceAziendale, P.NomeAzienda, COUNT(S.NoradID) AS NumSatelliti FROM Produttore P JOIN Satellite S ON P.CodiceAziendale = S.Produttore GROUP BY P.CodiceAziendale, P.NomeAzienda";
            res = PQexec(conn, query3);
            checkResults(res, conn);

            //stampa risultato
            int tuple = PQntuples(res);
            int campi = PQnfields(res);
            printf("Ecco il numero di satelliti prodotti da ciascun produttore!.\n");
            printf("\n");
            printf("%-30s%-30s%-30s\n",
            "Codice Aziendale",
            "Nome Azienda",
            "Numero Satelliti");
            printResult(tuple, campi, res);
            PQclear(res);
        }


        //query 4
        else if (numero_query == 4) {
            const char* query4 = "SELECT R.PIN, SUM(M.Durata) AS DurataTotale FROM Robot R JOIN MissioneRobotica MR ON R.PIN = MR.Robot JOIN Missione M ON MR.Missione = M.CodMissione GROUP BY R.PIN";
            res = PQprepare(conn, "query4", query4, 1, NULL);

            res = PQexec(conn, query4);
            checkResults(res, conn);

            //stampa risultato
            int tuple = PQntuples(res);
            int campi = PQnfields(res);
            printf("Ecco la durata totale delle missioni robotiche per ciascun robot.\n");
            printf("\n");
            printf("%-30s%-30s\n",
            "PIN",
            "Durata Totale");
            printResult(tuple, campi, res);
            PQclear(res);
        }


        //query 5
        else if (numero_query == 5) {
            const char* query5 = "SELECT E.AgenziaSpaziale, COUNT(DISTINCT E.LID) AS NumEsperimenti FROM Esperimento E JOIN MissioneSperimentale MS ON E.LID = MS.Esperimento GROUP BY E.AgenziaSpaziale";
            res = PQexec(conn, query5);
            checkResults(res, conn);
            
            //stampa risultato
            int tuple = PQntuples(res);
            int campi = PQnfields(res);
            printf("Ecco numero di esperimenti coinvolti in missioni per agenzia spaziale.\n");
            printf("\n");
            printf("%-30s%-30s\n",
            "Agenzia Spaziale",
            "Numero Esperimenti");
            printResult(tuple, campi, res);
            PQclear(res);
        }



        printf("Vuoi eseguire un'altra query? Premi 0 se si. Se invece vuoi uscire, premi 1\n");
        scanf_s("%d", &termina); //se termina=1 il programma si ferma, se è 0 ricomincia
    }
        
        PQfinish(conn);
        printf("\nProgramma terminato.\n");
        system("pause"); // per non fare terminare subito il programma
        return 0;
}
