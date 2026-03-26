import Foundation

/// Serviço responsável pelo armazenamento persistente de conversas
class StorageService {
    static let shared = StorageService()

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let conversationsKey = "bitnet.conversations"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - File Manager Properties
    private let fileManager = FileManager.default
    private lazy var documentsDirectory: URL = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }()

    private lazy var conversationsFileURL: URL = {
        documentsDirectory.appendingPathComponent("conversations.json")
    }()

    // MARK: - Initialization
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Public Methods

    /// Salva todas as conversas
    func saveConversations(_ conversations: [Conversation]) {
        do {
            let data = try encoder.encode(conversations)

            // Salva em arquivo
            try data.write(to: conversationsFileURL, options: .atomic)

            // Backup em UserDefaults
            userDefaults.set(data, forKey: conversationsKey)

            print("💾 \(conversations.count) conversas salvas com sucesso")
        } catch {
            print("❌ Erro ao salvar conversas: \(error.localizedDescription)")
        }
    }

    /// Carrega todas as conversas
    func loadConversations() -> [Conversation] {
        // Tenta carregar do arquivo primeiro
        if let data = try? Data(contentsOf: conversationsFileURL),
           let conversations = try? decoder.decode([Conversation].self, from: data) {
            print("📂 \(conversations.count) conversas carregadas do arquivo")
            return conversations
        }

        // Fallback para UserDefaults
        if let data = userDefaults.data(forKey: conversationsKey),
           let conversations = try? decoder.decode([Conversation].self, from: data) {
            print("📂 \(conversations.count) conversas carregadas do UserDefaults")
            return conversations
        }

        print("📂 Nenhuma conversa encontrada, iniciando limpo")
        return []
    }

    /// Deleta todas as conversas
    func deleteAllConversations() {
        try? fileManager.removeItem(at: conversationsFileURL)
        userDefaults.removeObject(forKey: conversationsKey)
        print("🗑️ Todas as conversas foram deletadas")
    }

    /// Exporta conversas para compartilhamento
    func exportConversations(_ conversations: [Conversation]) -> URL? {
        do {
            let data = try encoder.encode(conversations)
            let tempURL = fileManager.temporaryDirectory
                .appendingPathComponent("bitnet_export_\(Date().timeIntervalSince1970).json")

            try data.write(to: tempURL, options: .atomic)
            return tempURL
        } catch {
            print("❌ Erro ao exportar conversas: \(error.localizedDescription)")
            return nil
        }
    }

    /// Importa conversas de arquivo
    func importConversations(from url: URL) -> [Conversation]? {
        do {
            let data = try Data(contentsOf: url)
            let conversations = try decoder.decode([Conversation].self, from: data)
            print("📥 \(conversations.count) conversas importadas")
            return conversations
        } catch {
            print("❌ Erro ao importar conversas: \(error.localizedDescription)")
            return nil
        }
    }

    /// Retorna informações de armazenamento
    func getStorageInfo() -> StorageInfo {
        var totalSize: Int64 = 0

        if let attributes = try? fileManager.attributesOfItem(atPath: conversationsFileURL.path),
           let size = attributes[.size] as? Int64 {
            totalSize = size
        }

        let conversationCount = loadConversations().count

        return StorageInfo(
            totalSizeBytes: totalSize,
            conversationCount: conversationCount,
            lastBackupDate: try? fileManager.attributesOfItem(atPath: conversationsFileURL.path)[.modificationDate] as? Date
        )
    }
}

// MARK: - Storage Info
struct StorageInfo {
    let totalSizeBytes: Int64
    let conversationCount: Int
    let lastBackupDate: Date?

    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: totalSizeBytes)
    }
}
