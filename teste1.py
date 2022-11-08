from custom_utility import *


# recebendo o url
url = extract_links('https://www.gov.br/ans/pt-br/assuntos/consumidor/o-que-o-seu-plano-de-saude-deve-cobrir-1/o-que-e-o-rol-de-procedimentos-e-evento-em-saude')

# filtrando os urls por extensão
urls_pdf = filter_extension_link(urls=url, extension='.pdf')
urls_xlsx = filter_extension_link(urls=url, extension='.xlsx')

# filtando os urls por nome
dict_pdf = filter_target_link(urls=urls_pdf, word='Anexo')
dict_xlsx = filter_target_link(urls=urls_xlsx, word='Anexo')
dict_pdf_xlsx = dict_pdf | dict_xlsx

# baixando os documentos
for key in dict_pdf_xlsx:
    download_file(dict_url=dict_pdf_xlsx[key], name=key, folder='output_teste_1')

# comprimindo documentos
extension_files = ['*.pdf', '*.xlsx']
compress_file(folder='output_teste_1', zip_name='anexos.zip', extension=extension_files)
