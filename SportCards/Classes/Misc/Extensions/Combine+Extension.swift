//
//  Combine+Extension.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import Foundation
import Combine

extension Publisher {
    func shareReplay(_ bufferSize: Int) -> AnyPublisher<Output, Failure> {
        return multicast(subject: ReplaySubject(bufferSize)).autoconnect().eraseToAnyPublisher()
    }
    
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map { .success($0)}
            .catch { Just(.failure($0) ) }
            .eraseToAnyPublisher()
    }
    
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        self.map { _ in () }
            .eraseToAnyPublisher()
    }
}

final class ReplaySubject<Output, Failure: Error>: Subject {
    private var buffer = [Output]()
    private let bufferSize: Int
    private let lock = NSRecursiveLock()

    init(_ bufferSize: Int = 0) {
        self.bufferSize = bufferSize
    }
    
    private var subscriptions = [ReplaySubjectSubscription<Output, Failure>]()
    private var completion: Subscribers.Completion<Failure>?

    func receive<Downstream: Subscriber>(subscriber: Downstream) where Downstream.Failure == Failure, Downstream.Input == Output {
        lock.lock(); defer { lock.unlock() }
        let subscription = ReplaySubjectSubscription<Output, Failure>(downstream: AnySubscriber(subscriber))
        subscriber.receive(subscription: subscription)
        subscriptions.append(subscription)
        subscription.replay(buffer, completion: completion)
    }
}
extension ReplaySubject {

    func send(subscription: Subscription) {
        lock.lock(); defer { lock.unlock() }
        subscription.request(.unlimited)
    }

    func send(_ value: Output) {
        lock.lock(); defer { lock.unlock() }
        buffer.append(value)
        buffer = buffer.suffix(bufferSize)
        subscriptions.forEach { $0.receive(value) }
    }

    func send(completion: Subscribers.Completion<Failure>) {
        lock.lock(); defer { lock.unlock() }
        self.completion = completion
        subscriptions.forEach { subscription in subscription.receive(completion: completion) }
    }
}

final class ReplaySubjectSubscription<Output, Failure: Error>: Subscription {
    private let downstream: AnySubscriber<Output, Failure>
    private var isCompleted = false
    private var demand: Subscribers.Demand = .none

    init(downstream: AnySubscriber<Output, Failure>) {
        self.downstream = downstream
    }

    func request(_ newDemand: Subscribers.Demand) {
        demand += newDemand
    }

    func cancel() {
        isCompleted = true
    }

    func receive(_ value: Output) {
        guard !isCompleted, demand > 0 else { return }

        demand += downstream.receive(value)
        demand -= 1
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        guard !isCompleted else { return }
        isCompleted = true
        downstream.receive(completion: completion)
    }

    func replay(_ values: [Output], completion: Subscribers.Completion<Failure>?) {
        guard !isCompleted else { return }
        values.forEach { value in receive(value) }
        if let completion = completion { receive(completion: completion) }
    }
}
