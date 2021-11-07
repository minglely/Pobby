//
//  WelcomeViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/10/27.
//
import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startPobby: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    override open var shouldAutorotate: Bool {
    return false
    }
    
    //MARK: data for the slides
    var imgs = ["welcome_1","welcome_2","welcome_3","welcome_4"]
    
    //get dynamic width and height of scrollview and save it
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        startPobby.layer.cornerRadius = 20

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //crete the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        for index in 0..<imgs.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            imageView.frame = CGRect(x:0,y:0,width:scrollWidth-50,height:300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }
        
    //set width of scrollview to accomodate all the slides
    scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(imgs.count), height: scrollHeight)
        
    //initial state
    pageControl.numberOfPages = imgs.count
    pageControl.currentPage = 0
    }
    
    //indicator
    @IBAction func pageChanged(_ sender: Any) {
    scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    setIndiactorForCurrentPage()
    }
    func setIndiactorForCurrentPage()  {
    let page = (scrollView?.contentOffset.x)!/scrollWidth
    pageControl?.currentPage = Int(page)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
    }

}
