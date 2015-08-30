import sys, sqlite3, csv


argvs = sys.argv

con = sqlite3.connect(argvs[1])
intbl = argvs[2]
tblname = argvs[3]

con.execute("DROP TABLE IF EXISTS " + tblname)
con.execute("CREATE TABLE " + tblname + """ (
	cat integer
	, uid integer
	, id_0 integer
	, iso varchar(3)
	, name_0 varchar(255)
	, id_1 integer
	, name_1 varchar(255)
	, varname_1 varchar(255)
	, nl_name_1 varchar(255)
	, hasc_1 varchar(255)
	, ccn_1 varchar(255)
	, cca_1 varchar(255)
	, type_1 varchar(255)
	, engtype_1 varchar(255)
	, validfr_1 varchar(255)
	, validto_1 varchar(255)
	, remarks_1 varchar(255)
	, id_2 integer
	, name_2 varchar(255)
	, varname_2 varchar(255)
	, nl_name_2 varchar(255)
	, hasc_2 varchar(255)
	, ccn_2 varchar(255)
	, cca_2 varchar(255)
	, type_2 varchar(255)
	, engtype_2 varchar(255)
	, validfr_2 varchar(255)
	, validto_2 varchar(255)
	, remarks_2 varchar(255)
	, id_3 integer
	, name_3 varchar(255)
	, varname_3 varchar(255)
	, nl_name_3 varchar(255)
	, hasc_3 varchar(255)
	, ccn_3 varchar(255)
	, cca_3 varchar(255)
	, type_3 varchar(255)
	, engtype_3 varchar(255)
	, validfr_3 varchar(255)
	, validto_3 varchar(255)
	, remarks_3 varchar(255)
	, id_4 integer
	, name_4 varchar(255)
	, varname_4 varchar(255)
	, ccn_4 varchar(255)
	, cca_4 varchar(255)
	, type_4 varchar(255)
	, engtype_4 varchar(255)
	, validfr_4 varchar(255)
	, validto_4 varchar(255)
	, remarks_4 varchar(255)
	, id_5 integer
	, name_5 varchar(255)
	, ccn_5 varchar(255)
	, cca_5 varchar(255)
	, type_5 varchar(255)
	, engtype_5 varchar(255)
	, region varchar(255)
	, varregion varchar(255)
	, unam varchar(255)
	, zone varchar(255)
	, shape_length double precision
	, shape_area double precision
	, rast_n double precision
	, rast_min double precision
	, rast_max double precision
	, rast_range double precision
	, rast_mean double precision
	, rast_stddev double precision
	, rast_variance double precision
	, rast_cf_var double precision
	, rast_sum double precision
	, rast_first_quartile double precision
	, rast_median double precision
	, rast_third_quartile double precision
	, rast_percentile_90 double precision
	);
""")


reader = csv.reader(open(argvs[2], 'r'), delimiter='|')
for row in reader:
	print len(row)
	to_db = [unicode(row[0], "utf8")]
	for i in range(1, len(row)):
		to_db.append(unicode(row[i], "utf8"))

	con.execute("INSERT INTO "+ tblname + " VALUES ("+ "?," * (len(row) - 1) + " ?);", to_db)
con.commit()
