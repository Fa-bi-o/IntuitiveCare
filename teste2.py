import os
import tabula
import pandas as pd
from custom_utility import compress_file

# carregando o arquivo específico da pasta do teste anterior
list_files = os.listdir('./output_teste_1')
file = [link for link in list_files if link.endswith('.pdf') and link.startswith('Anexo_I_')]

# utilzando tabula, para ler o pdf
document = tabula.read_pdf(f'output_teste_1/{file[0]}', pages='3-180', area=[119, 0, 900, 1600],
                           pandas_options={'header': None})

# corrigindo formatação dos textos
clean_table = []
for table in document:
    clean_table.append(table.replace(r'(\n|\\n)', '').replace(r'(\r|\\r)', ' '))

# criando dataframe vazio para adicionar as tabelas
data = pd.DataFrame()

# adicionando as tabelas corrigidas ao dataframe
for table in range(len(clean_table)):
    data_temp = pd.DataFrame(clean_table[table])
    frames = [data, data_temp]
    data = pd.concat(frames)

# adicionando as colunas ao dataframe, também feita a alteração solicitada no teste_2
data.columns = ['PROCEDIMENTO', 'RN (alteração)', 'VIGÊNCIA',
                'Seg. Odontologia', 'Seg. Ambulatorial', 'HCO',
                'HSO', 'REF', 'PAC', 'DUT', 'SUBGRUPO', 'GRUPO', 'CAPÍTULO']

# o dataframe ficou com uma linha extra, então é feito o drop dessa linha
data = data.dropna(subset=['PROCEDIMENTO'])

# criando pasta para o teste_2 caso ela não exista
if not os.path.isdir('./output_teste_2'):
    os.makedirs('./output_teste_2')

# convertando o dataframe para csv
path = f'./output_teste_2'
file_name = 'Teste_2_Fabio_Nascimento.csv'
path_name = os.path.join(path, file_name)

data.to_csv(path_name, sep=';', index=False, header=True, encoding='utf-8-sig')

# salvando o arquivo csv em formato.zip
extension_files = ['*.csv']
compress_file(folder='output_teste_2', zip_name='Teste_2_Fabio_Nascimento.zip', extension=extension_files)
