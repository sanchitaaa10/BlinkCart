import '../models/faq_item.dart';

class MockFaqs {
  static const List<FaqItem> faqs = [
    FaqItem(
      id: 'faq-1',
      category: 'Delivery & Timing',
      question: 'How does BlinkCart deliver in 10–20 minutes?',
      answer: 'We operate a dense network of hyper-local temperature-controlled micro-fulfillment dark stores across your neighborhood. Orders are picked and packed in under 2.5 minutes by specialized store associates and handed directly to nearby electric delivery partners.',
    ),
    FaqItem(
      id: 'faq-2',
      category: 'Freshness & Quality',
      question: 'What is the BlinkCart Freshness Guarantee?',
      answer: 'Fruits and vegetables are harvested and direct-sourced from certified local farms every morning at 4 AM. If you are not 100% satisfied with the quality of any produce item, you can initiate an instant 1-tap refund or replacement right at your doorstep.',
    ),
    FaqItem(
      id: 'faq-3',
      category: 'Returns & Refunds',
      question: 'What is the return and refund policy?',
      answer: 'We offer a hassle-free, no-questions-asked return policy at the time of delivery. If an item is missing, damaged, or not to your satisfaction, you can return it to the delivery partner immediately or request an instant refund to your BlinkCart Wallet or original payment method via the order screen.',
    ),
    FaqItem(
      id: 'faq-4',
      category: 'Payments & Wallet',
      question: 'Which payment methods are supported?',
      answer: 'We accept Google Pay, PhonePe, Paytm, all UPI apps, Visa, MasterCard, RuPay debit & credit cards, Net Banking, BlinkCart Wallet, and Cash / QR on Delivery (COD).',
    ),
    FaqItem(
      id: 'faq-5',
      category: 'Safety & Hygiene',
      question: 'How are fresh and cold-chain items handled?',
      answer: 'All dairy, paneer, juices, and cold items are stored in dedicated 2°C–4°C chilling chambers in our dark stores and transported in insulated thermal delivery bags to ensure maximum freshness throughout transit.',
    ),
    FaqItem(
      id: 'faq-6',
      category: 'Orders & Tracking',
      question: 'How do I share the delivery OTP?',
      answer: 'When your delivery partner arrives at your doorstep, you will see a 4-digit Delivery OTP on your live order tracking screen. Simply share this code verbally upon handover to verify and complete the delivery safely.',
    ),
  ];
}
