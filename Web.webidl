[Exposed=Window]
interface ExampleBufferFeature {
  undefined writeInto(ArrayBufferView dest);
  undefined writeIntoResizable([AllowResizable] ArrayBufferView dest);
  undefined writeIntoShared([AllowShared] ArrayBufferView dest);
  undefined writeIntoSharedResizable([AllowResizable, AllowShared] ArrayBufferView dest);
};
