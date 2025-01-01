import Foundation
import CoreData
import Combine

protocol MovieDetailDao {
    func insert(_ item: MovieDetail) -> AnyPublisher<Void, Error>
    func fetch(movieId: Int) -> AnyPublisher<MovieDetail, Error>
    func deleteMovieDetail(movieId: Int) -> AnyPublisher<Void, Error>
}

class MovieDetailDaoImpl: MovieDetailDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insert(_ item: MovieDetail) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    guard let movieDetailEntity = MovieDetailEntity.insertNew(in: context) else { return }
                    movieDetailEntity.budget = Int32(item.budget ?? 0)
                    movieDetailEntity.id = Int32(item.id)
                    movieDetailEntity.originalLanguage = item.originalLanguage ?? ""
                    movieDetailEntity.overview = item.overview ?? ""
                    movieDetailEntity.posterPath = item.posterPath ?? ""
                    movieDetailEntity.releaseDate = item.releaseDate ?? ""
                    movieDetailEntity.revenue = Int32(item.revenue ?? 0)
                    movieDetailEntity.title = item.title ?? ""
                    movieDetailEntity.voteAverage = item.voteAverage ?? 0
                    movieDetailEntity.voteCount = Int32(item.voteCount ?? 0)
                    
                    item.genres?.enumerated().forEach { (genreIndex, genre) in
                        guard let genresEntity = MovieDetailGenresEntity.insertNew(in: context) else { return }
                        genresEntity.id = Int32(genre.id)
                        genresEntity.name = genre.name
                        genresEntity.genresRelation = movieDetailEntity
                        movieDetailEntity.addToGenres(genresEntity)
                    }
                    
                    item.productionCompanies?.enumerated().forEach { (productionCompanyIndex, productionCompany) in
                        guard let productionCompanyEntity = MovieDetailProductionCompaniesEntity.insertNew(in: context) else { return }
                        productionCompanyEntity.id = Int32(productionCompany.id)
                        productionCompanyEntity.name = productionCompany.name ?? ""
                        productionCompanyEntity.originCountry = productionCompany.originCountry ?? ""
                        productionCompanyEntity.productionCompaniesRelation = movieDetailEntity
                        movieDetailEntity.addToProductionCompanies(productionCompanyEntity)
                    }
                    
                    item.productionCountries?.enumerated().forEach { (productionCountryIndex, productionCountry) in
                        guard let productionCountryEntity = MovieDetailProductionCountriesEntity.insertNew(in: context) else { return }
                        productionCountryEntity.isoDate = productionCountry.isoDate ?? ""
                        productionCountryEntity.name = productionCountry.name ?? ""
                        productionCountryEntity.productionCountriesRelation = movieDetailEntity
                        movieDetailEntity.addToProductionCountries(productionCountryEntity)
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
    
    func fetch(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieDetailEntity> = MovieDetailEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            request.relationshipKeyPathsForPrefetching = ["genres", "productionCompanies", "productionCountries"]
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    guard let movieDetailEntity = try context.fetch(request).first else { return }

                    let genres: [Genre] = (movieDetailEntity.genres?.allObjects as? [MovieDetailGenresEntity])?.map {
                        genreEntity in
                        Genre(
                            id: Int(genreEntity.id),
                            name: genreEntity.name ?? ""
                        )
                    } ?? []
                    
                    let productionCompanies: [ProductionCompany] = (movieDetailEntity.productionCompanies?.allObjects as? [MovieDetailProductionCompaniesEntity])?.map {
                        productionCompanyEntity in
                        ProductionCompany(
                            id: Int(productionCompanyEntity.id),
                            name: productionCompanyEntity.name ?? "",
                            originCountry: productionCompanyEntity.originCountry ?? ""
                        )
                    } ?? []
                    
                    let productionCountries: [ProductionCountry] = (movieDetailEntity.productionCountries?.allObjects as? [MovieDetailProductionCountriesEntity])?.map {
                        productionCountryEntity in
                        ProductionCountry(
                            isoDate: productionCountryEntity.isoDate ?? "",
                            name: productionCountryEntity.name ?? ""
                        )
                    } ?? []
                    
                    let movieDetail = MovieDetail(
                        budget: Int(movieDetailEntity.budget), 
                        genres: genres, 
                        id: Int(movieDetailEntity.id), 
                        originalLanguage: movieDetailEntity.originalLanguage, 
                        overview: movieDetailEntity.overview, 
                        posterPath: movieDetailEntity.posterPath, 
                        productionCompanies: productionCompanies, 
                        productionCountries: productionCountries, 
                        releaseDate: movieDetailEntity.releaseDate, 
                        revenue: Int(movieDetailEntity.revenue), 
                        title: movieDetailEntity.title, 
                        voteAverage: movieDetailEntity.voteAverage, 
                        voteCount: Int(movieDetailEntity.voteCount)
                    )
                    
                    promise(.success(movieDetail))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteMovieDetail(movieId: Int) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieDetailEntity> = MovieDetailEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    if let movieDetailEntity = try context.fetch(request).first {
                        context.delete(movieDetailEntity)
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
