import Foundation

public class QueueFactory {
    private static let queueKey = DispatchSpecificKey<String>()

    static let queue: DispatchQueue = {
        let q = DispatchQueue(label: "NEKit.ProcessingQueue")
        q.setSpecific(key: QueueFactory.queueKey, value: "NEKit.ProcessingQueue")
        return q
    }()

    public static func getQueue() -> DispatchQueue {
        return QueueFactory.queue
    }

    public static func onQueue() -> Bool {
        return DispatchQueue.getSpecific(key: QueueFactory.queueKey) == "NEKit.ProcessingQueue"
    }

    public static func executeOnQueueSynchronizedly<T>(block: () throws -> T ) rethrows -> T {
        if onQueue() {
            return try block()
        } else {
            return try getQueue().sync {
                return try block()
            }
        }
    }
}
