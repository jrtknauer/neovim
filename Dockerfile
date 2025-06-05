FROM ubuntu:24.04 AS build

ARG NEOVIM_VERSION
ENV NEOVIM_VERSION=${NEOVIM_VERSION:-v0.11.2}

WORKDIR /build

RUN <<EOF
apt-get update
apt-get \
	--no-install-recommends \
	--quiet \
	--yes \
	install \
	build-essential \
	cmake \
	curl \
	gettext \
	gcc \
	ninja-build
rm --force --recursive /var/lib/apt/lists/*
EOF

COPY . .

RUN <<EOF
git switch $NEOVIM_VERSION
make CMAKE_BUILD_TYPE="Release" CMAKE_INSTALL_PREFIX="/build/out"
make install
EOF

FROM scratch AS output

COPY --from=build /build/out /

ENTRYPOINT ["/"]
