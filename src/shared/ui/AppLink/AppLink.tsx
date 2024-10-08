import React, { type FC } from 'react';
import cls from './AppLink.module.scss';
import { Link, type LinkProps } from 'react-router-dom';
import { classNames } from 'shared/helpers/classNames/classNames';

export enum AppLinkTheme {
  PRIMARY = 'primary',
  SECONDARY = 'secondary',
}

export interface AppLinkProps extends LinkProps {
  className?: string;
  theme?: AppLinkTheme;
}

export const AppLink: FC<AppLinkProps> = (props) => {
  const {
    to,
    className,
    children,
    theme = AppLinkTheme.PRIMARY,
    ...otherProps
  } = props;
  return (
    <Link
      className={classNames(cls.AppLink, {}, [className ?? '', cls[theme]])}
      to={to}
      {...otherProps}
    >
      {children}
    </Link>
  );
};
