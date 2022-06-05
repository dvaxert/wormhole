#include "wormhole/internal/wormhole_internal.h"

namespace wh {
namespace internal {

InternalClass::InternalClass(int val) : val_(val) {}

int InternalClass::AnotherTestFunc() { return val_; }

}  // namespace internal
}  // namespace wh
