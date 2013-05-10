#!/bin/bash

# Funcao para verificar se os programas a serem utilizados
# se encontram em PATH
esta_instalado(){
    prog=$1
    echo "Verificando se $prog está instalado ..."
    for caminho in ${PATH//:/ }
        do
            if [ -x "$caminho/$prog" ]; then
	        echo "     OK"
                return 0
            fi
        done
    echo "     $prog não foi encontrado"
    return 1
}

# saida do mario_fortunes -- deve ser usada no lugar de exit
mf_exit(){
    rm -f $ERRO
    rm -f $OPT
    rm -f $TMP
    exit $1
}

# Saida sem erro
saida(){
    $DIALOG --clear
    $DIALOG --msgbox "A instalação NÃO foi concluída com sucesso." 24 80
    $DIALOG --clear
    mf_exit 1
}

# Saida por causa de erro
saida_por_erro(){
    $DIALOG --clear
    $DIALOG --msgbox "Ocorreu um erro.\n\nA instalação NÃO foi concluída com sucesso.\n\n$1" 24 80
    $DIALOG --clear
    mf_exit 1
}

if esta_instalado Xdialog && [ ! -z $DISPLAY ]
then
    DIALOG=Xdialog
else
    esta_instalado dialog ||  mf_exit 1
    DIALOG=dialog
fi

[ $DIALOG = Xdialog ] && ALIGN="--left"

TMP=/tmp/mario_fortunes
OPT=/tmp/opt
ERRO=/tmp/erro
ARQS="mario.anagramas mario.arteascii mario.computadores mario.gauchismos mario.geral mario.palindromos mario.piadas"

# Verifica se os programas utilizados no instalador estao
# disponiveis
esta_instalado gawk || esta_instalado awk || mf_exit 1
esta_instalado grep || mf_exit 1
esta_instalado strfile || mf_exit 1
esta_instalado fortune || mf_exit 1

# Verifica se e' possivel escrever em /tmp
touch $TMP || {
      echo "Nao e' possivel criar $TMP"
      mf_exit 1
}


#Iniciando a interface com o usuario
$DIALOG --msgbox "`cat LEIAME`" 24 80

# Verifica onde o fortune le^ os arquivos de frases
DIRS=`fortune -f 2>&1 |grep "/"| gawk '{print $2}'`

CAMINHOS=""
CONT=0

for CAMINHO in $DIRS
do
    CAMINHOS="$CAMINHOS $(( $CONT + 1)) $CAMINHO"
    CONT=$(( $CONT + 1 ))
done
CAMINHOS="$CAMINHOS $(( $CONT + 1 )) Outro"

$DIALOG --menu "Escolha o diretório para instalar o arquivo de frases" \
        24 80 15 \
        $CAMINHOS 2> $TMP

[ -z `cat $TMP` ] && saida

$DIALOG --clear

# Se o usuario prefere outro diretorio que nao um dos apresentados,
# deve-se deixar que ele digite um caminho
if [ `cat $TMP` = `expr $CONT + 1` ] 
then
    cat /dev/null > $TMP
    $DIALOG --inputbox \
       "Digite o diretório para instalar o arquivo de frases" \
       24 80 2> $TMP
       echo -e "\ndigitou" >> $TMP
fi

[ -z `head -n1 $TMP` ] && saida_por_erro "Você deve especificar o diretório onde quer instalar o mario_fortunes."


# Se foi escolhido um dos caminhos sugeridos, coloca-se ele em $TMP
# Essa volta toda e' necessaria porque o dialog retorna a primeira
# coluna do menu (um numero) e queremos a segunda (caminho)
CONT=$(( $CONT * 2 ))
if [ ! `tail -n1 $TMP` = digitou ]
then
    echo $CAMINHOS | awk '{print $'$CONT'}' > $TMP
else
    CAMINHO=`head -n1 $TMP`
    echo $CAMINHO > $TMP
fi
    

# Se o diretorio nao existe, da'-se um jeito
[ -d `cat $TMP` ] || {
    $DIALOG --clear
    $DIALOG --menu "O diretório especificado não existe. Deseja criá-lo?" \
	    24 80 15 \
	    1 Sim \
	    2 Nao \
	    2> $OPT

    [ -z `cat $OPT` ] && saida

    if [ `cat $OPT` = 1 ]
    then
	mkdir -p `cat $TMP` 2> $ERRO || saida_por_erro "`cat $ERRO`"
    else 
	saida
    fi
}

# Gerando os arquivos .dat e copiando-os para o diretorio destino
DIR=`cat $TMP`

for i in $ARQS
do
    strfile $i 2> $ERRO || saida_por_erro "`cat $ERRO`"
    cp -f $i "$i".dat $DIR 2> $ERRO || saida_por_erro "`cat $ERRO`"
done

# Mensagens finais
$DIALOG --clear
$DIALOG --msgbox "A instalação do mario_fortunes foi concluída com sucesso.\n\nVeja o arquivo DICAS para obter idéias de como usar o mario_fortunes.\n\nSugestões de frases podem ser enviadas para mario@proxy.furg.br." 24 80

$DIALOG $ALIGN --msgbox "mario_fortunes: (mario.geral)\n\n`fortune $DIR/mario.geral`" 24 80

# Tchau
mf_exit 0


