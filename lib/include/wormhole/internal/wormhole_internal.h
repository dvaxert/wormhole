#ifndef WORMHOLE_LIB_WORMHOLE_INTERNAL_WORMHOLE_INTERNAL_H_
#define WORMHOLE_LIB_WORMHOLE_INTERNAL_WORMHOLE_INTERNAL_H_

namespace wh {
namespace internal {

class InternalClass {
 public:
  InternalClass(int val);
  ~InternalClass() = default;

  int AnotherTestFunc();

 private:
  int val_;
};

}  // namespace internal
}  // namespace wh

#endif  // WORMHOLE_LIB_WORMHOLE_INTERNAL_WORMHOLE_INTERNAL_H_
