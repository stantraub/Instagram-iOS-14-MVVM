//
//  ProfileController.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 10/23/20.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    private var posts = [Post]()
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
        
//        PostService.updateUserFeedAfterFollowingUser(user: user, didFollow: true)
    }
    
    //MARK: - API
    
    private func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
            self?.user.isFollowed = isFollowed
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { [weak self] stats in
            self?.user.stats = stats
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    
    //MARK: - Helpers
    
    private func configureCollectionView() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.identifier)
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.identifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        
        return header
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonForUser user: User) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { [weak self] error in
                self?.user.isFollowed = false
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
                PostService.updateUserFeedAfterFollowingUser(user: user, didFollow: false)

            }
        } else {
            UserService.follow(uid: user.uid) { [weak self] error in
                self?.user.isFollowed = true
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
                NotificationService.uploadNotification(toUid: user.uid,
                                                       fromUser: currentUser,
                                                       type: .follow)
                
                PostService.updateUserFeedAfterFollowingUser(user: user, didFollow: true)

            }
        }
    }
    
    
}

