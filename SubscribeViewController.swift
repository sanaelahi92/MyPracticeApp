/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class SubscribeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet var tableView: UITableView!
  
  // MARK: - Instance Properties
  
  var options: [Subscription]?
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 55
    tableView.rowHeight = UITableViewAutomaticDimension
    options = SubscriptionService.shared.options
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleOptionsLoaded(notification:)),
                                           name: SubscriptionService.optionsLoadedNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseSuccessfull(notification:)),
                                           name: SubscriptionService.purchaseSuccessfulNotification,
                                           object: nil)
  }
  
  func handleOptionsLoaded(notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      self?.options = SubscriptionService.shared.options
      self?.tableView.reloadData()
    }
  }
  
  func handlePurchaseSuccessfull(notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func back(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource

extension SubscribeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath) as! SubscriptionOptionTableViewCell
    guard let option = options?[indexPath.row] else { return cell }
    
    cell.nameLabel.text = option.product.localizedTitle
    cell.descriptionLabel.text = option.product.localizedDescription
    cell.priceLabel.text = option.formattedPrice
    
    if let currentSubscription = SubscriptionService.shared.currentSubscription {
      if option.product.productIdentifier == currentSubscription.productId {
        cell.isCurrentPlan = true
      }
    }
        
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SubscribeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let option = options?[indexPath.row] else { return }
    SubscriptionService.shared.purchase(subscription: option)
  }
}
