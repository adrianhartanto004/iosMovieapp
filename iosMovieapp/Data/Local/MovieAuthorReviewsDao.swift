import Foundation
import CoreData
import Combine

protocol MovieAuthorReviewsDao {
    func insertAll(movieId: Int, _ items: [AuthorReview]) -> AnyPublisher<Void, Error>
    func fetch(movieId: Int) -> AnyPublisher<[AuthorReview], Error>
    func deleteMovieAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error>
}

class MovieAuthorReviewsDaoImpl: MovieAuthorReviewsDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insertAll(movieId: Int, _ items: [AuthorReview]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    guard let movieAuthorReviewListEntity = MovieAuthorReviewListEntity.insertNew(in: context) else { return }
                    movieAuthorReviewListEntity.id = Int32(movieId)
                    
                    items.enumerated().forEach { (authorReviewIndex, authorReview) in
                        guard let movieAuthorReviewsEntity = MovieAuthorReviewsEntity.insertNew(in: context)
                            else { return }
                        movieAuthorReviewsEntity.index = Int32(authorReviewIndex)
                        movieAuthorReviewsEntity.id = authorReview.id
                        movieAuthorReviewsEntity.author = authorReview.author
                        movieAuthorReviewsEntity.rating = authorReview.authorDetails?.rating ?? 0
                        movieAuthorReviewsEntity.avatarPath = authorReview.authorDetails?.avatarPath
                        movieAuthorReviewsEntity.content = authorReview.content
                        movieAuthorReviewsEntity.updatedAt = authorReview.updatedAt
                        movieAuthorReviewsEntity.authorReviewsRelation = movieAuthorReviewListEntity
                        movieAuthorReviewListEntity.addToAuthorReviews(movieAuthorReviewsEntity)
                    }
                    
                    if context.hasChanges == true {
                        try context.save()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieAuthorReviewListEntity> = MovieAuthorReviewListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            request.relationshipKeyPathsForPrefetching = ["authorReviews"]
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    guard let movieAuthorReviewListEntity = try context.fetch(request).first else { return }

                    let authorReviews: [AuthorReview] = (movieAuthorReviewListEntity.authorReviews?.allObjects as? [MovieAuthorReviewsEntity])?.sorted(by: { $0.index < $1.index} ).map { authorReview in
                        AuthorReview(
                            author: authorReview.author, 
                            authorDetails: AuthorDetails(avatarPath: authorReview.avatarPath, rating: authorReview.rating), 
                            content: authorReview.content, 
                            id: authorReview.id ?? "", 
                            updatedAt: authorReview.updatedAt
                        )
                    } ?? []
                    
                    promise(.success(authorReviews))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteMovieAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieAuthorReviewListEntity> = MovieAuthorReviewListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    if let movieAuthorReviewListEntity = try context.fetch(request).first {
                        context.delete(movieAuthorReviewListEntity)
                    }
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
