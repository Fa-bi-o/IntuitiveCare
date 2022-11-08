import os
import requests
from bs4 import BeautifulSoup
from zipfile import ZIP_DEFLATED, ZipFile
from pathlib import Path


def extract_links(link):
    """
        Função responsável por extrair de uma url todos os links contidos na página.
        Retorna uma lista com todos os links
    """

    reqs = requests.get(link)
    soup = BeautifulSoup(reqs.text, "html.parser")

    urls = []
    for link in soup.findAll('a'):
        urls.append(link.get('href'))

    return urls


def filter_extension_link(urls, extension):
    """
        Função responsável por filtrar de uma lista de urls, os links que terminem com a extensão escolhida pelo
        utilizador, recebendo como entra uma lista e a extensão do arquivo, no formato '.extensão'.

        Retornar uma lista com todos os links da extensão escolhida.
    """

    urls_list = [link for link in urls if link.endswith(extension)]
    return urls_list


def filter_target_link(urls, word):
    """
        Função responsável por filtrar de uma lista de urls, os links que contenham a palavra escolhida como nome do
        documento.

        O url é separado por '/' para facilitar a identificação do documento, essas ‘strings’ são colocadas
        numa lista temporária, logo é verificado se algum dos elementos corresponde a palavra utilizada como filtro.

        É considerado o nome no começo da ‘string’, limitando-se ao tamanho da palavra escolhida como filtro.

        Ex.: A palavra 'Anexo' como filtro, em um url = 'https:://exemplo/pratico/Anexo_documento_escolhido'
        terá o link filtrado por conter a palavra filtrada no elemento temporário 'Anexo_documento_escolhido'.

        Retorna um dicionário contendo o nome do arquivo (chave) e o link (valor) da palavra escolhida.
    """

    dict_links = {}
    for link in urls:
        temp_list = link.split('/')

        for element in temp_list:
            if element[0:len(word)] == word:
                dict_links[element] = link
    return dict_links


def download_file(dict_url, name, folder):
    """
        Função responsável por baixar os documentos em um url, recebe como parâmetro de entrada, um dicinonário
        contendo o nome do arquivo (chave), link (valor), o nome que o documento terá (name)' e a pasta (folder)
        onde o arquivo será salvo, caso a pasta não exista ela será criada.
    """

    if not os.path.isdir(f'./{folder}'):
        os.makedirs(f'./{folder}')

    r = requests.get(dict_url, stream=True)
    path = f'./{folder}'
    file_name = name
    path_name = os.path.join(path, file_name)

    with open(path_name, 'wb') as f:

        for chunk in r.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)
    f.close()
    return


def compress_file(folder, zip_name, extension):
    """
        Função responsável por 'zipar' os arquivos, recebe como parâmentro o nome da pasta (folder), o nome
        do arquivo, e as extensões dos arquivos.
        Ex.: folder='output_teste_1', zip_name='anexos.zip, extension=[*.pdf, *.xlsx']
     """

    directory = Path(f'{folder}/')
    path_name = os.path.join(directory, zip_name)

    with ZipFile(path_name, 'w', ZIP_DEFLATED) as zf:
        for ext in extension:
            for document in directory.rglob(ext):
                zf.write(document)
    zf.close()
