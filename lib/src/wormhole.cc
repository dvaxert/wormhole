#include "wormhole/internal/wormhole_internal.h"
#include "wormhole/wormhole.h"

namespace wh {

TestBuild::TestBuild() {}

int TestBuild::TestFunc() {
  auto internal = std::make_unique<internal::InternalClass>(5);
  return internal->AnotherTestFunc();
}

}  // namespace wh
