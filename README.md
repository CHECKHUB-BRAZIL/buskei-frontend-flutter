# 📱 Aplicativo Flutter – Busca e Comparação de Produtos

Este é um aplicativo desenvolvido em **Flutter**, projetado para oferecer uma experiência rápida e intuitiva na **busca, visualização e comparação de produtos**.  
O app se conecta a uma API (FastAPI) para obter dados atualizados sobre preços, características e disponibilidade em diferentes lojas.

---

## 🚀 Funcionalidades

- Busca de produtos por nome ou categoria  
- Visualização de detalhes do produto  
- Comparação entre diferentes lojas/fornecedores  
- Interface moderna e responsiva  
- Integração com API externa  
- Suporte a Android e iOS  

---

## ▶️ Como rodar o projeto

### 1. Instalar dependências
No diretório do projeto:

```bash
flutter pub get

```bash
flutter run

```bash
flutter build apk/ flutter build ios

---

## 🔗 Integração com API (FastAPI)

Este app consome dados da API de produtos para buscar e comparar itens.
A URL base da API pode ser configurada em:

lib/services/api_service.dart
