import pandas as pd 
import numpy as np
from math import sin, cos, sqrt, atan2, radians
import collections
import re

#Read data
dataset = pd.read_excel(r'dataset.xlsx')

dataset['PONTO_RECOLHA_FREGUESIA'] = dataset['PONTO_RECOLHA_FREGUESIA'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
dataset['PONTO_RECOLHA_LOCAL'] = dataset['PONTO_RECOLHA_LOCAL'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
dataset['CONTENTOR_RESÍDUO'] = dataset['CONTENTOR_RESÍDUO'].str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')


full = open('pontos_recolha.pl','w+',encoding='utf-8')
full.write('%%pontorecolha(ID,Lat,Long,Rua,[RuasAdjecentes],tipo)\n')
contentRE = re.compile(
	r'\d{5}: ([A-Za-z0-9 \-]*)[ ,](\(.*\): (.+) - (.+)\))?')

def tipotoint(tipo):
	i = 0
	if tipo == 'Lixos':
	 i = 0
	elif tipo == 'Organicos':
	 i = 1
	elif tipo == 'Papel e Cartao':
	 i = 2
	elif tipo == 'Embalagens':
	 i = 3
	elif tipo == 'Vidro':
	 i = 4
	return i

adjacentes = collections.defaultdict(set)
ruas = dict()
tipos = dict()
qt = dict()

for line in dataset.values:
	ponto = re.search(contentRE, line[4])
	if ponto:
		rua = ponto.group(1)
		if not(rua in ruas):
			ruas[rua] = [line[0],line[1]]
			tipos[rua] = [0,0,0,0,0]
			qt[rua] = [0,0,0,0,0]

		t = tipotoint(line[5])

		tipos[rua][t] = 1
		qt[rua][t] += line[9]
		if ponto.group(2):
			adj1 = ponto.group(3)
			adj2 = ponto.group(4)
			if not(rua in adjacentes[adj1]):
				adjacentes[rua].add(adj1)
			if not(rua in adjacentes[adj2]):
				adjacentes[rua].add(adj2)

	#full.write("ponto_recolha(%d,%f,%f,'%s',%s,'%s',%d).\n" %(line[2],line[0],line[1],rua,adjacente,line[5],line[9]))
#full.close()


for item in ruas.keys():
	if tipos[item][0] == 1:
		full.write("ponto_recolha(%f,%f,'%s',%d,%d).\n" %(ruas[item][0],ruas[item][1],item,0,qt[item] [0]))
	if tipos[item][1] == 1:
		full.write("ponto_recolha(%f,%f,'%s',%d,%d).\n" %(ruas[item][0],ruas[item][1],item,1,qt[item][1]))
	if tipos[item][2] == 1:
		full.write("ponto_recolha(%f,%f,'%s',%d,%d).\n" %(ruas[item][0],ruas[item][1],item,2,qt[item] [2]))
	if tipos[item][3] == 1:
		full.write("ponto_recolha(%f,%f,'%s',%d,%d).\n" %(ruas[item][0],ruas[item][1],item,3,qt[item] [3]))
	if tipos[item][4] == 1:
		full.write("ponto_recolha(%f,%f,'%s',%d,%d).\n" %(ruas[item][0],ruas[item][1],item,4,qt[item] [4]))

#Calculate distance
def calc2_distance(latitude1,longitude1,latitude2,longitude2):
    result = np.sqrt(  (latitude1-latitude2)**2 + (longitude1-longitude2)**2 )
    return result

def calc_distance(lat1,lon1,lat2,lon2): 
    # Raio aproximado da terra 
    R = 6371.0 
 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
 
    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2 
    c = 2 * atan2(sqrt(a), sqrt(1 - a)) 
 
    distance = R * c 
 
    return distance 

full2 = open('arco.pl','w+',encoding='utf-8')
full2.write('%%arco(Rua1,Rua2,Distancia)\n')

for item in adjacentes.items():
	for rua in item[1]:
		if (item[0] in ruas) and (rua in ruas):
			full2.write("arco('%s','%s',%f).\n" %(item[0],rua,calc_distance(ruas[item[0]][0],ruas[item[0]][1],ruas[rua][0],ruas[rua][1])))
full2.close()  
     
