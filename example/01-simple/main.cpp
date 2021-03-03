/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include <soralog/impl/configurator_from_yaml.hpp>
#include <soralog/injector.hpp>

#include "logging_object.hpp"

template <typename Injector>
std::shared_ptr<soralog::ConfiguratorFromYAML> get_configurator(
    const Injector &injector) {
  static auto cfg = std::make_shared<soralog::ConfiguratorFromYAML>(
      "../../../example/01-simple/logger.yml");
  return cfg;
}

int main() {
  auto injector = soralog::injector::makeInjector(

      // Replace fallback configurator by ConfiguratorFromYAML
      boost::di::bind<soralog::Configurator>.to([](const auto &i) {
        return get_configurator(i);
      })[boost::di::override]

  );

  auto &log_system = injector.create<soralog::LoggerSystem &>();

  auto r = log_system.configure();
  if (not r.message.empty()) {
    std::cerr << r.message << std::endl;
  }
  if (r.has_error) {
    return EXIT_FAILURE;
  }

  auto main_log =
      injector.create<soralog::LoggerFactory &>().getLogger("main", "main");

  main_log->info("Start");

  auto &object = injector.create<LoggingObject &>();

  object.method();

  main_log->info("Finish");

  return 0;
}