#SchemaFix
The SchemaFix tool has been designed for Mobile Iron Core servers that ran into MIDB schema mismatch issues (after say, an upgrade). The tool works by taking a known schema file (included or can be manually uploaded) and comparing this against your current schema file, and outputs the MySQL code necessary to get the two match up again. The tool is written in Java (JavaFX).

#Usage
SchemaFix comes with both a GUI-mode as a text-only mode. The GUI mode speaks for itself. The text-only mode offers the following parameters:

`--gold-schema [-g]  :   Set the gold schema file to compare against`
`--corrupted-schema [-c] :   Set the corrupted schema file to be compared`
`--out [-o]  :   Set the out file to write the results to (optional, defaults to STDOUT)`
`--help      :   Show a help message`

######Example usage:
`$ java -jar schemafix.jar --gold-schema in.sql --corrupted-schema corrupted.sql --out /tmp/output.sql`

#Disclaimer
This tool has been designed for Mobile Iron troubleshooting purposes, and should be used with extreme caution. The software is provided 'as is' and is to be used at your own risk.
