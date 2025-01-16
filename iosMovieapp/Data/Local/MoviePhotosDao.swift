import Foundation
import CoreData
import Combine

protocol MoviePhotosDao {
    func insertAll(movieId: Int, _ items: [Photo]) -> AnyPublisher<Void, Error>
    func fetch(movieId: Int) -> AnyPublisher<[Photo], Error>
    func deleteMoviePhoto(movieId: Int) -> AnyPublisher<Void, Error>
}

class MoviePhotosDaoImpl: MoviePhotosDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insertAll(movieId: Int, _ items: [Photo]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    guard let moviePhotoListEntity = MoviePhotoListEntity.insertNew(in: context) else { return }
                    moviePhotoListEntity.id = Int32(movieId)
                    
                    items.enumerated().forEach { (photoIndex, photo) in
                        guard let moviePhotosEntity = MoviePhotosEntity.insertNew(in: context)
                            else { return }
                        moviePhotosEntity.index = Int32(photoIndex)
                        moviePhotosEntity.filePath = photo.filePath
                        moviePhotosEntity.photosRelation = moviePhotoListEntity
                        moviePhotoListEntity.addToPhotos(moviePhotosEntity)
                    }
                    
                    try context.saveIfNeeded()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MoviePhotoListEntity> = MoviePhotoListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            request.relationshipKeyPathsForPrefetching = ["photos"]
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.perform {
                do {
                    guard let moviePhotoListEntity = try context.fetch(request).first else { return promise(.failure(CoreDataError.dataNotAvailable)) }

                    let photos: [Photo] = (moviePhotoListEntity.photos?.allObjects as? [MoviePhotosEntity])?.sorted(by: { $0.index < $1.index} ).map  {
                        photoEntity in
                        Photo(filePath: photoEntity.filePath)
                    } ?? []
                    
                    promise(.success(photos))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteMoviePhoto(movieId: Int) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MoviePhotoListEntity> = MoviePhotoListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.perform {
                do {
                    if let moviePhotoListEntity = try context.fetch(request).first {
                        context.delete(moviePhotoListEntity)
                    }
                    try context.saveIfNeeded()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
