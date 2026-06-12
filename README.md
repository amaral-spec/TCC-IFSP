# Reconhecimento de Expressões Faciais com Machine Learning para TEA

Este repositório apresenta o projeto de TCC de **Gabriel do Amaral de Oliveira**, desenvolvido no **IFSP – Campus Campinas**, com foco no desenvolvimento de uma aplicação iOS baseada em aprendizado de máquina para o reconhecimento de expressões faciais como ferramenta assistiva para pessoas com Transtorno do Espectro Autista (TEA).

---

## Objetivo

Desenvolver e validar um protótipo de aplicativo iOS capaz de identificar expressões faciais em tempo real, utilizando modelos de machine learning treinados com o dataset FER-2013, com o propósito de apoiar a comunicação e a leitura emocional por pessoas com TEA.

---

## Tecnologias Utilizadas

- **Machine Learning:**
  - Create ML (treinamento e validação do modelo)
  - Core ML (integração do modelo ao iOS)
  - Vision / VisionFeaturePrint (extração de features faciais)
- **Dataset:** FER-2013 (Facial Expression Recognition 2013)
- **Desenvolvimento Mobile:** Swift, UIKit / SwiftUI
- **Métricas de Avaliação:** Precisão, Recall, F1-score, Matriz de Confusão
- **Plataforma:** Xcode, iOS Simulator, dispositivo físico

---

## Expressões Reconhecidas

O modelo foi treinado para classificar as seguintes expressões faciais, baseadas nas categorias do dataset FER-2013:

| Classe       | Descrição              |
|--------------|------------------------|
| `happy`      | Feliz                  |
| `surprise`   | Surpresa               |

---

## Principais Resultados

- Modelo treinado e validado com o dataset FER-2013 via **Create ML**
- Integração bem-sucedida com **Core ML** e o framework **Vision** no iOS
- Inferência em tempo real via câmera frontal do dispositivo
- Protótipo funcional validado como **prova de conceito assistiva** para o contexto do TEA
- Métricas de validação documentadas com matriz de confusão e F1-score por classe

---

## Métricas Avaliadas

- Acurácia geral do modelo
- Precisão (*Precision*) por classe
- Recall por classe
- F1-score por classe
- Matriz de Confusão

---

## Como Executar

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/tcc-expressoes-faciais-tea.git
   ```

2. **Abra o projeto no Xcode:**
   ```
   Abra ExpressionRecognizer.xcodeproj no Xcode 14+
   ```

3. **Configure o target:**
   - Selecione um simulador iOS 16+ ou um dispositivo físico
   - Certifique-se de que o `.mlmodel` está corretamente adicionado ao bundle

4. **Execute o aplicativo:**
   - Pressione `Cmd + R` para compilar e rodar
   - Conceda permissão de câmera quando solicitado
   - Aponte a câmera para um rosto para ver o reconhecimento em tempo real

> **Nota:** Para uso da câmera, é recomendado rodar em dispositivo físico, pois o simulador possui suporte limitado a câmera.

---

## Contexto: TEA e Reconhecimento Emocional

Pessoas com Transtorno do Espectro Autista frequentemente apresentam dificuldades na leitura e interpretação de expressões faciais, o que pode impactar diretamente nas interações sociais. Este projeto propõe uma ferramenta tecnológica de baixo custo — um aplicativo iOS — como suporte à identificação de emoções em tempo real, contribuindo para a autonomia e qualidade de vida de pessoas com TEA.

---

## Autor

**Gabriel do Amaral de Oliveira**   
IFSP – Campus Campinas  
Contato: [seu-email@aluno.ifsp.edu.br](mailto:gabrielamaral1301@gmail.com)

---

## Referências

- APPLE INC. *Core ML Documentation*. Disponível em: https://developer.apple.com/documentation/coreml
- APPLE INC. *Create ML Documentation*. Disponível em: https://developer.apple.com/documentation/createml
- APPLE INC. *Vision Framework Documentation*. Disponível em: https://developer.apple.com/documentation/vision

---

## Licença

Projeto acadêmico — uso livre para fins educacionais e de pesquisa.
