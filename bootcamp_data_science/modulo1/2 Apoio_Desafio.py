{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "Apoio_TP.ipynb",
      "provenance": [],
      "collapsed_sections": []
    },
    "kernelspec": {
      "name": "python3",
      "display_name": "Python 3"
    }
  },
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "3xNakTR1b6jS"
      },
      "source": [
        "*IMPORTANDO AS BIBLIOTECAS NECESSÁRIAS*"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "9vvpgozjbycW"
      },
      "source": [
        "import pandas as pd\r\n",
        "import numpy as np\r\n",
        "from matplotlib import pyplot as plt\r\n",
        "import plotly as py\r\n",
        "import plotly.graph_objs as go\r\n",
        "from sklearn.datasets import make_blobs\r\n",
        "from sklearn.cluster import KMeans"
      ],
      "execution_count": 1,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "gEFo2saOb_2Y"
      },
      "source": [
        "*FAÇA O UPLOAD DO DATASET Mall_Customers.csv PARA O GOOGLE COLAB*\r\n"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "LbutbvK7b5hx"
      },
      "source": [
        "#Se necessário, troque o caminho do arquivo.\r\n",
        "\r\n",
        "df = pd.read_csv('/content/Consumo.csv', sep=',', encoding='1252')\r\n",
        "df.head()"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "AUPZgAAFU4Dv"
      },
      "source": [
        "**PLOTANDO O GRÁFICO DE RENDA X PONTUAÇÃO**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "ai_Dp4A6Ua1C"
      },
      "source": [
        "plt.scatter(x = 'Salario Anual (milhares)', y = 'Score Gastos (0-100)', data = df)\r\n",
        "plt.title('Renda Anual x Pontuação de Gastos')\r\n",
        "plt.show()"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "J9CcobeNc1kl"
      },
      "source": [
        "**EXECUÇÃO DO KMEANS COM 2 CLUSTERS**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "W1LXkVwxdu9r"
      },
      "source": [
        "X2 = df[['Salario Anual (milhares)', 'Score Gastos (0-100)']].iloc[:,:].values\r\n",
        "\r\n",
        "#Insira aqui o código que executa o algoritmo k-means com 2 clusters."
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "VB1u_Sq2eT4V"
      },
      "source": [
        "**EXECUÇÃO DO KMEANS COM 6 CLUSTERS**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "VJUj-gSgeYrl"
      },
      "source": [
        "#Insira aqui o código que executa o algoritmo k-means com 6 clusters."
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "hmLOIbVQcVPu"
      },
      "source": [
        "*EXIBIÇÃO DA CURVA DO COTOVELO, MOSTRANDO AS ITERAÇÕES E O NÚMERO IDEAL DE CLUSTERS*"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "8o7FnVIBcnWx"
      },
      "source": [
        "wcss = []\r\n",
        "for i in range(1, 20):\r\n",
        "    kmeans = KMeans(n_clusters=i, init='k-means++', max_iter=300, n_init=10)\r\n",
        "    kmeans.fit(X2)\r\n",
        "    wcss.append(kmeans.inertia_)\r\n",
        "plt.plot(range(1, 20), wcss)\r\n",
        "plt.plot([1,19],[wcss[0], wcss[len(wcss)-1]])\r\n",
        "plt.title('Curva do cotovelo')\r\n",
        "plt.xlabel('Número de clusters')\r\n",
        "plt.ylabel('WCSS')\r\n",
        "plt.show()"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "XZwpgO9xenr5"
      },
      "source": [
        "**EXECUÇÃO DO KMEANS COM O NÚMERO IDEAL DE CLUSTERS**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "SKb9BTTaefxY"
      },
      "source": [
        "#Insira aqui o código que executa o algoritmo k-means com o número ideal de clusters"
      ],
      "execution_count": null,
      "outputs": []
    }
  ]
}