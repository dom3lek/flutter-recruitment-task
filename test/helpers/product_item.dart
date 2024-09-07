import 'package:flutter_recruitment_task/models/products_page.dart';

final product1 = Product(
  id: 'product1',
  name: 'Product 1',
  offer: Offer(
    regularPrice: Price(
      amount: 100,
      currency: 'USD',
    ),
    promotionalPrice: Price(
      amount: 80,
      currency: 'USD',
    ),
    sellerId: 'seller1',
    skuId: 'sku1',
    sellerName: 'seller1',
    subtitle: 'subtitle1',
    isSponsored: false,
    isBest: false,
    normalizedPrice: null,
    promotionalNormalizedPrice: null,
    omnibusPrice: null,
    omnibusLabel: null,
    tags: [],
  ),
  tags: [
    Tag(
      tag: 'VEGE',
      label: 'VEGE',
      color: '#1A22B490',
      labelColor: '#FFFFFF',
    ),
  ],
  mainImage: 'https://example.com/image.jpg',
  available: true,
  description: 'Description 1',
  sellerId: 'seller1',
  isFavorite: false,
  isBlurred: false,
);

final product2 = Product(
  id: 'product2',
  name: 'Product 2',
  offer: Offer(
    regularPrice: Price(
      amount: 100,
      currency: 'USD',
    ),
    promotionalPrice: Price(
      amount: 80,
      currency: 'USD',
    ),
    sellerId: 'seller2',
    skuId: 'sku2',
    sellerName: 'seller2',
    subtitle: 'subtitle2',
    isSponsored: false,
    isBest: false,
    normalizedPrice: null,
    promotionalNormalizedPrice: null,
    omnibusPrice: null,
    omnibusLabel: null,
    tags: [],
  ),
  tags: [
    Tag(
      tag: 'VEGE',
      label: 'VEGE',
      color: '#1A22B490',
      labelColor: '#FFFFFF',
    ),
  ],
  mainImage: 'https://example.com/image.jpg',
  available: true,
  description: 'Description 2',
  sellerId: 'seller2',
  isFavorite: false,
  isBlurred: false,
);
