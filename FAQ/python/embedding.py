from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer

app = Flask(__name__)

# モデルをアプリ起動時に一度だけロード（VectorSearch.clsと同じモデルに統一）
model = SentenceTransformer('stsb-xlm-r-multilingual')

@app.route('/embedding', methods=['POST']) 
def embed():
    data = request.get_json(force=True)
    sentence = data.get('sentence')
    if not sentence:
        return jsonify({'error': 'No sentence provided'}), 400
    # L2ノルム正規化でエンベディング
    embedding = model.encode(sentence, normalize_embeddings=True)
    embedding = str(embedding.tolist()).replace('[', '').replace(']', '')
    return jsonify({'embedding': embedding})

@app.route('/')
def home():
    return "Flask app is running!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=10905)